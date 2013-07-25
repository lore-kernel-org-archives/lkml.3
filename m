Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3GYEP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 00:15:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41844 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab3GYEPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 00:15:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130724220631.GA10541@kroah.com>
References: <1374476192-7801-1-git-send-email-wonkang@gctsemi.com>
	<1374690977-10877-1-git-send-email-wonkang@gctsemi.com>
	<20130724215340.GY5585@mwanda>
	<20130724220631.GA10541@kroah.com>
Date: Thu, 25 Jul 2013 13:15:07 +0900
Message-ID: <CABe_0=+bXAuXhG+XG4ObUO_2MYD_XWxF_wbTVrpKagmHi8_CDQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] staging: gdm7240: adding LTE USB driver
From: Won Kang <wkang77@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        wonkang@gctsemi.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GDM7240 is in LE where as GDM7243 (currently under development) is in BE.

User space applications needs to discover the endianess to properly
encode/decode LTE control protocols. We have existing customers
already deploying units in large volume, and want to avoid forcing
them to change SDK APIs along with kernel updates.
At some point, It will have to be fixed with SDK API can interoperate properly.

On Thu, Jul 25, 2013 at 7:06 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Jul 25, 2013 at 12:53:40AM +0300, Dan Carpenter wrote:
>> > +static int gdm_lte_ioctl_get_data(struct wm_req_t *req, struct net_device *dev)
>> > +{
>> > +   u16 id = req->data_id;
>> > +
>> > +   switch (id) {
>> > +   case GET_ENDIAN_INFO:
>> > +           /* required for the user space application to find out device endian */
>> > +           get_dev_endian(&req->data, dev);
>> > +           break;
>> > +   default:
>> > +           printk(KERN_ERR "glte: ioctl - unknown type %d\n", id);
>> > +           break;
>> > +   }
>> > +   return 0;
>> > +}
>>
>> This should be a sysfs file not an ioctl.  What would break if we
>> fixed this right now (as opposed to waiting until we can't change
>> the API?).
>>
>> Otherwise if we can't change this, then it should return an error
>> code instead of printing a message.
>
> It should just be removed, why would you care about the endian-ness of
> the device at all?
>
> thanks,
>
> greg k-h
