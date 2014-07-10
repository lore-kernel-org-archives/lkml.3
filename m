Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaGJW7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:59:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51179 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaGJW7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 18:59:03 -0400
Message-ID: <53BF1A94.50009@zytor.com>
Date: Thu, 10 Jul 2014 15:58:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
CC: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ix86: fix vDSO build
References: <53B5863B02000078000204D5@mail.emea.novell.com>
In-Reply-To: <53B5863B02000078000204D5@mail.emea.novell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 07:35 AM, Jan Beulich wrote:
> Relying on static functions used just once to get inlined (and
> subsequently have dead code paths eliminated) is wrong: Compilers are
> free to decide whether they do this, regardless of optimization level.
> With this not happening for vdso_addr() (observed with gcc 4.1.x), an
> unresolved reference to align_vdso_addr() causes the build to fail.

The fix seems odd... more of the flavor of "happens to work" unless I'm
misunderstanding something.  If this needs to be inlined, wouldn't
__always_inline make more sense?

What am I missing?

	-hpa

