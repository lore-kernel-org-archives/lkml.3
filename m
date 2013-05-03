Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762555Ab3ECDSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 23:18:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39135 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab3ECDSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 23:18:11 -0400
Message-ID: <51832C6C.1030805@zytor.com>
Date: Thu, 02 May 2013 20:18:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Warlich, Christof" <christof.warlich@siemens.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: X86 fpu registers in a signal handler's ucontext
References: <6D83E89737156549AEA25EF9ED712C5DDEF7@DEFTHW99EK1MSX.ww902.siemens.net>
In-Reply-To: <6D83E89737156549AEA25EF9ED712C5DDEF7@DEFTHW99EK1MSX.ww902.siemens.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 07:34 AM, Warlich, Christof wrote:
> Second, only FP state seems to be available through ucontext_t, and I would
> need to clear exceptions for SSE as well.

Not true.

> Can anyone give me some advice on how to I could proceed?

To optimize the common case, if the signal handler doesn't touch the FPU
the state is not reloaded from the signal stack.  Therefore you need to
execute an FPU instruction -- pretty much any FPU instruction -- in your
signal handler in order to force the reload.

	-hpa

