Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935666AbaDJOca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:32:30 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:17774 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758501AbaDJOc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:32:28 -0400
X-AuditID: cbfec37c-b7f536d0000059f2-1a-5346ab79e431
Message-id: <5346AB76.1020800@samsung.com>
Date: Thu, 10 Apr 2014 08:32:22 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, tj@kernel.org,
        rafael.j.wysocki@intel.com, linux@roeck-us.net, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [RFC PATCH 0/2] managed token devres interfaces
References: <cover.1397050852.git.shuah.kh@samsung.com>
 <20140409191740.GA10748@kroah.com> <5345CD32.8010305@samsung.com>
 <20140410120435.4c439a8b@alan.etchedpixels.co.uk>
 <20140410083841.488f9c43@samsung.com>
In-reply-to: <20140410083841.488f9c43@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.250]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+wr27lardgg91fJCwmTfnLZtG8eD2b
	xeVdc9gsejZsZbV4svAMk8XjFW/ZLb7+dLD4tfwoo8W2WwtZHDg9ds66y+6xa9tOJo/Fe14y
	eWxa1cnmsX/uGnaP1pObWD12fm9g9/i8SS6AI4rLJiU1J7MstUjfLoErY9mbM4wFFzgq5vZv
	ZGlgPMvWxcjJISFgIrH91UQWCFtM4sK99UBxLg4hgWWMEiu+X2aBcHqZJFZOv8sEUiUksI1R
	YuVSIRCbV0BLor/pODOIzSKgKvG9fwojiM0moC7x+fUOdoh6OYmmJavBakQFIiRenYXYxisg
	KPFj8j0gm4NDRCBF4vrfcJBdzAKfGSW2zdsFVi8sYCOx/9oVFog51xklWo8Ug9icAkYSN5p+
	g93DLGAtsXLSNkYIW15i85q3zBD1yhJ/Lp9igvhMWWLjoXcsExhFZiFZPQtJ+ywk7QsYmVcx
	ipUWJxcUJ6WnVhjrFSfmFpfmpesl5+duYoREXs0OxntfbQ4xCnAwKvHwHljmGizEmlhWXJl7
	iFGCg1lJhHfjVLdgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzTznU4cIf5PF5kHrtr6VLZQpE9
	Zxoey/kVPd0b7en18K7YtnXPHQ19rl2J7ljdlPY83U58hvP9xzZcD/+F11W56Qh67lDa1FU1
	M+jL/nl7n3NPf6H+6+OOh0xhh8tnbDoqkvuDc/bJv6Js1WfrGN81ZLZEHj5k4O0YbxfMeXJO
	oIh7Tm7tfWclluKMREMt5qLiRAC1u/6XmgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 05:38 AM, Mauro Carvalho Chehab wrote:
> Hi Alan,
>
> Em Thu, 10 Apr 2014 12:04:35 +0100
> One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> escreveu:
>
>>>>>    - Construct string with (dev is struct em28xx *dev)
>>>>> 		format: "tuner:%s-%s-%d"
>>>>> 		with the following:
>>>>>      	            dev_name(&dev->udev->dev)
>>>>>                   dev->udev->bus->bus_name
>>>>>                   dev->tuner_addr
>>
>> What guarantees this won't get confused by hot plugging and re-use of the
>> bus slot ?
>
> Good point. Yes, this should be addressed.
>

This resource should be destroyed when em28xx_ handles unplug from its 
em28xx_usb_disconnect() or in generic words, in its "uninit". It is a 
matter of making sure this resource is handled in the "uninit" for this 
media device/driver(s) like any other shared resource.

Would that cover the hot plugging and re-use of the bus slot scenario?

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
