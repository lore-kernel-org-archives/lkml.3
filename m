Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbaDJFbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 01:31:15 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:34810 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaDJFbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 01:31:13 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1404092134420.7397-100000@netrider.rowland.org>
References: <001a01cf5453$243d9c70$6cb8d550$%han@samsung.com>
	<Pine.LNX.4.44L0.1404092134420.7397-100000@netrider.rowland.org>
Date: Thu, 10 Apr 2014 11:01:12 +0530
X-Google-Sender-Auth: vV2QFDNOGz14d6R_IiF4xMZy3O0
Message-ID: <CAFp+6iGTbvK+7BTg6mDohiOqyaOHLuDzDTyXWeCkgS2YUApBJQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] usb: ehci-exynos: Return immediately from suspend if
 ehci_suspend fails
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jingoo Han <jg1.han@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,


On Thu, Apr 10, 2014 at 7:06 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 10 Apr 2014, Jingoo Han wrote:
>
>> > > --- a/drivers/usb/host/ehci-exynos.c
>> > > +++ b/drivers/usb/host/ehci-exynos.c
>> > > @@ -212,6 +212,8 @@ static int exynos_ehci_suspend(struct device *dev)
>> > >   int rc;
>> > >
>> > >   rc = ehci_suspend(hcd, do_wakeup);
>> > > + if (rc)
>> > > +         return rc;
>> > >
>> > >   if (exynos_ehci->otg)
>> > >           exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
>> > > @@ -221,7 +223,7 @@ static int exynos_ehci_suspend(struct device *dev)
>> > >
>> > >   clk_disable_unprepare(exynos_ehci->clk);
>> > >
>> > > - return rc;
>> > > + return 0;
>> > >  }
>> > >
>> > >  static int exynos_ehci_resume(struct device *dev)
>> >
>> > The first hunk of this patch is correct, but the second hunk isn't
>> > needed.  A similar remark is true for the ehci-platform patch.
>>
>> Hi Alan,
>>
>> Do you mean the following?
>>
>> 1st hunk
>>  +    if (rc)
>>  +            return rc;
>>
>> 2nd hunk
>>  -    return rc;
>>  +    return 0;
>
> Yes, that's what I mean.
>
>> Currently, the 'rc' will be always 'zero'; however, I don't
>> Have any objection, because the code might be  modified later.
>
> Exactly.  We should add the new "if" statement but leave the "return
> rc" the way it is.

Sure, i will update both the patches.

>
> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
