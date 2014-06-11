Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbaFKPYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:24:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47469 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbaFKPYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:24:21 -0400
Message-ID: <5398749B.4090209@zytor.com>
Date: Wed, 11 Jun 2014 08:24:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Josh Boyer <jwboyer@fedoraproject.org>
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: vdso_install target broken post-3.15
References: <CA+5PVA4srNrj2xqMYH40N13rV+jC-PbLdyNpoURomTq48cJNBA@mail.gmail.com> <CA+5PVA7gL6T2eXAy6G4hGJzhKZ_8KHd0qauKqzuHAP4oTJ97QA@mail.gmail.com> <CALCETrXG=752GrPhP8zKJUciiagCVRO0kenDOqL78eP73Y3ryA@mail.gmail.com>
In-Reply-To: <CALCETrXG=752GrPhP8zKJUciiagCVRO0kenDOqL78eP73Y3ryA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 08:20 AM, Andy Lutomirski wrote:
> 
> Is vdso_install supposed to install a .so file or just a .so.dbg file?
>  I'm having trouble parsing this:
> 
> quiet_cmd_vdso_install = INSTALL $@
>       cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
> $(vdso-install-y): %.so: $(obj)/%.so.dbg FORCE
>         @mkdir -p $(MODLIB)/vdso
>         $(call cmd,vdso_install)
> 
> This seems like a rather complicated way of saying that the .so.dbg is
> installed with the .dbg at the end removed.  We can do that.  Let me
> see if I can disentangle the makefile enough.
> 

That is, indeed, what it says.

> If we need real stripped .so files, vdso2c knows how to generate them,
> but the makefile doesn't invoke it like that.  I don't see why we'd
> want to install them, though.

I don't think there is any point in that.

	-hpa

