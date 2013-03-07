Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab3CGDls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:41:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49793 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab3CGDlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:41:47 -0500
Message-ID: <51380C65.50202@zytor.com>
Date: Wed, 06 Mar 2013 19:41:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: 3.9-rc1: hz.bc compilation breakage
References: <5137546B.2090801@free-electrons.com>
In-Reply-To: <5137546B.2090801@free-electrons.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 06:36 AM, Maxime Ripard wrote:
> Hi,
> 
> I'm compiling the kernel for an iMX28(ARM) board, and since 3.9-rc1, I
> get the following error at compilation time:
> 
> make[3]: *** No rule to make target
> `/home/max/Work/2012/crystalfontz/rewrite/linux-dt/include/config/hz.h',
> needed by `kernel/hz.bc'.  Stop.
> 
> I'm doing a clean out-of-tree build, with the following configuration
> file: http://code.bulix.org/m4y7se-83102?raw
> 
> Reverting commit 1b66e0fd ("kernel: Replace timeconst.pl with a bc
> script") make the compilation go on as usual.
> 

That file should have been created by "make *config", and I just
verified that it does indeed do so.  That file is a sentinel for
configuration changes; the entire build system depends on it.

I am not sure what you mean with "clean out-of-tree", however.

kbuild people: is there anything wrong with how this dependency is
specified?

	-hpa


