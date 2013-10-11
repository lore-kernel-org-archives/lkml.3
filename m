Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3JKWFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:05:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab3JKWFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:05:44 -0400
Message-ID: <1381529474.4278.24.camel@dcbw.foobar.com>
Subject: Re: [PATCH 1/1] support new huawei devices in option.c
From: Dan Williams <dcbw@redhat.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heyongquan <heyongquan@huawei.com>, Wangyuhua <yuhua.wang@huawei.com>,
        "Yili (Neil)" <neil.yi@huawei.com>
Date: Fri, 11 Oct 2013 17:11:14 -0500
In-Reply-To: <20131011205756.GA8181@kroah.com>
References: <910F9D9E13B84F4C8FA771DC9BDE99F35E24BA90@szxema506-mbs.china.huawei.com>
	 <20131011205756.GA8181@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 13:57 -0700, gregkh@linuxfoundation.org wrote:
> On Fri, Oct 11, 2013 at 03:48:21AM +0000, Fangxiaozhi (Franko) wrote:
> > 1. Add new supporting declarations to option.c, to support Huawei new devices with new bInterfaceSubClass value.
> > Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> 
> In the future, can you use an email client that doesn't turn tabs into
> spaces, so I don't have to edit the patch by hand?
> 
> Also:
> 
> > + { USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x01) },
> > + { USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x02) },
> 
> <snip>
> 
> That's a huge list of ids, is there any way we can just mark all of
> these as used by the device in an easier manner?
> 
> I'll take this for now, but I have a feeling that this list is just
> going to get worse over time, right?

This is very, very odd.  Note the (ab)use of tons of subclass/protocol
numbers here to match devices instead of VID/PID.  Perhaps Huawei is
actually *running out* of PIDs or something?  There's no way every
single one of these devices actually speaks a different comm protocol on
these USB interfaces.  There has to be a reason that Huawei is now using
subclass/protocol for device matching instead of VID/PID like everyone
else is...

That said, I'm not sure there's much we can do about it.  But it still
raises one of my eyebrows up to the ceiling.

Dan

> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


