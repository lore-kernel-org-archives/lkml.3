Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762830Ab3DDQMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:12:45 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762605Ab3DDQMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:12:44 -0400
Message-ID: <515DA677.8050805@nod.at>
Date: Thu, 04 Apr 2013 18:12:39 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: "Fleming, Matt" <matt.fleming@intel.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "matthew.garrett@nebula.com" <matthew.garrett@nebula.com>
Subject: Re: [PATCH 1/2] efivars: Check max_size only if it is non-zero.
References: <1365080500-13677-1-git-send-email-richard@nod.at> <3908561D78D1C84285E8C5FCA982C28F1E0987DE@ORSMSX108.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1E0987DE@ORSMSX108.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.04.2013 18:00, schrieb Luck, Tony:
>> Some (broken?) EFI implementations return always a MaximumVariableSize of 0,
>> check against max_size only if it is non-zero.
>
> The spec doesn't say that zero has any special meaning - so if an implementation
> returns max_size == 0 but lets you set a variable to a size > 0, then I don't think
> there is a need for parentheses or a "?" in this commit comment.

Thanks for the clarification.
Yesterday I've looked into the spec, but the >2000 pages hurt my brain. ;-)

> But if Linux silently accepts such broken EFI, then there is no feedback loop
> to let EFI implementations know that they are broken.  In other areas we have
> thrown out messages about firmware being broken ... perhaps:
>
> 	if (max_size == 0)
> 		printk_once("Broken EFI implementation is returning MaxVariableSize=0\n");
>
> would help? After all there probably *is* a maximum size - but EFI isn't telling us what it is.

Fair point. I'll add such a printk() to my patch and resend.

Thanks,
//richard

