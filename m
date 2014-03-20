Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbaCTJPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:15:52 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:59584 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaCTJPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:15:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140320042700.GA11505@redhat.com>
References: <1394818263-29947-1-git-send-email-tytso@mit.edu>
	<1394818720.3253.1.camel@joe-AO722>
	<20140314180258.GA29201@thunk.org>
	<87y509scl3.fsf@rustcorp.com.au>
	<1395032434.2556.10.camel@joe-AO722>
	<1395041214.2556.17.camel@joe-AO722>
	<87zjkmr8w1.fsf@rustcorp.com.au>
	<1395211832.8649.40.camel@joe-AO722>
	<87k3bpr28n.fsf@rustcorp.com.au>
	<20140320042700.GA11505@redhat.com>
Date: Thu, 20 Mar 2014 12:15:48 +0300
Message-ID: <CACVxJT_WnkoUVxcLoraBAGpMB9jMaOqg8SY27RPLuym55o4J4Q@mail.gmail.com>
Subject: Re: Stricter module param and sysfs permission checks
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Jones <davej@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Joe Perches <joe@perches.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        fes@google.com, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Simon Wood <simon@mungewell.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 7:27 AM, Dave Jones <davej@redhat.com> wrote:
> On Thu, Mar 20, 2014 at 01:43:44PM +1030, Rusty Russell wrote:
>
>  > drivers/mtd/devices/docg3.c:
>  >      __ATTR(f##id##_dps0_protection_key, S_IWUGO, NULL, dps0_insert_key), \
>  >      __ATTR(f##id##_dps1_protection_key, S_IWUGO, NULL, dps1_insert_key), \
>  >
>  > drivers/scsi/pm8001/pm8001_ctl.c:
>  > static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUGO,
>  >      pm8001_show_update_fw, pm8001_store_update_fw);
>
> Why on earth are these world writable ?

Yup.

I like new and improved checks.
Rusty, add my "& 2" check everywhere!
