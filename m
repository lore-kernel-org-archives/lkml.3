Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaIQAVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 20:21:30 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:58645 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbaIQAV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 20:21:28 -0400
MIME-Version: 1.0
In-Reply-To: <8738brhzoc.fsf@tassilo.jf.intel.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
	<8738brhzoc.fsf@tassilo.jf.intel.com>
Date: Tue, 16 Sep 2014 17:21:27 -0700
Message-ID: <CABgu+=Na7A5amf_=QACrkgAAccf_VUaZMPJtzXb4K3D0FEasBw@mail.gmail.com>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
From: Richard Larocque <rlarocque@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 5:13 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Richard Larocque <rlarocque@google.com> writes:
>
> Perhaps I'm missing something, but how do you modify the AUX vector
> for the children?
>
>> +config VDSO_DISABLE_PRCTL
>> +     depends on X86
>> +     bool "prctl to disable VDSO loading"
>> +     ---help---
>> +       Enabling this option adds support for prctl calls that
>> +       set and retrieve a per-process flag to disable VDSO loading on
>> +       exec() for this process and all of its children.
>
> I don't think it makes any sense to have a config for a simple
> feature like this. Just do it unconditionally.
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

The AUX vector issue is a mistake on my part.

Speaking of mistakes, the IDs in the commit message do not match those
in the patch itself.  That needs to be fixed, too.

Point taken about the config.  I'll remove it in the next version of the patch.

Thanks for the feedback.
