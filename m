Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbaHGJsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:48:22 -0400
Received: from acledge1.advantech.com.tw ([61.58.41.197]:40502 "EHLO
	acledge1.advantech.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaHGJsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:48:21 -0400
From: Wei-Chun Pan <weichun.pan@advantech.com.tw>
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, Wolfram Sang <wsa@the-dreams.de>,
        "Louis.Lu" <Louis.Lu@advantech.com.tw>,
        "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>,
        <linux-kernel@vger.kernel.org>,
        Wei-Chun Pan <weichun.pan@advantech.com.tw>
Subject: RE: [PATCH 3/4] mfd: imanager2: Add Core supports for IT8516/18/28
Date: Thu, 7 Aug 2014 02:47:55 -0700
Message-ID: <1407404875-3705-1-git-send-email-weichun.pan@advantech.com.tw>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-StopIT: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question for your comment. As your mail,

> > +
> > +static void __exit imanager2_mfd_device_exit(void) {
> > +	mfd_remove_devices(&ec_pdev->dev);
> > +	platform_device_unregister(ec_pdev);
> > +}
> > +
> > +module_init(imanager2_mfd_device_init);
> > +module_exit(imanager2_mfd_device_exit);
> 
> This is a mess.  Use module_platform_driver() instead.
> 
> > +MODULE_AUTHOR("Richard Vidal-Dorsch <richard.dorsch at
> > +advantech.com>");
> > +MODULE_DESCRIPTION("iManager2 platform device definitions v"
> > +DRV_VERSION); MODULE_LICENSE("GPL"); MODULE_VERSION(DRV_VERSION);
> 

How can I use module_platform_driver() and my driver exit function also can do
mfd_remove_devices().
Or any other better function install of mfd_remove_devices()?

Signed-off-by: Wei-Chun Pan <weichun.pan@advantech.com.tw>
