Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab3HLRCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:02:15 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:49673 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab3HLRCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:02:13 -0400
X-AuditID: cbfec37b-b7f306d0000047de-56-5209151440fb
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] isa: Change driver to use dev_pm_ops infrastructure
Thread-topic: [PATCH] isa: Change driver to use dev_pm_ops infrastructure
Thread-index: AQHOld18lYTqavsD/UeX65TzDK6J4g==
Date: Mon, 12 Aug 2013 17:02:11 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E617633C7@sisaex02sj>
References: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
 <20130810185226.GA13293@kroah.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9hX10RUc4gg3n7jS2aF69ns7i8aw6b
	xdefDg7MHjtn3WX32D93DbvH501yAcxRXDYpqTmZZalF+nYJXBkPt+1kLZjEUfFtwW/GBsab
	bF2MHBwSAiYSq9fqdzFyApliEhfurQcKc3EICSxjlLh+fgc7hNPLJNF4YS0ThDOfUWLOr4WM
	IC1sAuoSn1+DVHFyiAhoSLw8eosFpIhZYDKjxOW3n5lBEsICHhJfX51jAlknIuApMbtPH6Je
	T2LTtn6wOSwCqhJ3Jm5lBbF5Bewlfi6GaBUSyJCYs+IvG4jNCHTe91NrmEBsZgFxiebWmywQ
	ZwtILNlznhnCFpV4+fgfK8RnihLbV1tBlGtJrN95HKpVW+LJuwtQqwQlfky+xzKBUWwWkqmz
	kLTMQtIyC0nLAkaWVYxipcXJBcVJ6akVRnrFibnFpXnpesn5uZsYIRFVvYPx7lebQ4wCHIxK
	PLwZHzmChFgTy4orcw8xSnAwK4nwbmHlDBLiTUmsrEotyo8vKs1JLT7EyMTBKdXAmHjs1vLE
	blavVpHIZu59GayNK7Ykd+p/ZK6bJ6pvaPfu6+Ovty/tTuhatH7iLIMt7BzfbEQUVvPYzZzb
	arWej/99RtOLjt5nvulbp7rUdDb9Zrzy1vXHs6VOExe8e7N7xltRvaAZRz8npX+4wvFmRjG/
	4ywzzWwhVrvHglH9ERcNzh99f2ddqhJLcUaioRZzUXEiAHY+8lSGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2013 12:51 PM, Greg KH wrote:
> On Sat, Aug 10, 2013 at 09:20:46AM -0600, Shuah Khan wrote:
>> Change isa bus to register dev_pm_ops via bus_type.pm. Add freeze ops for
>> PM_EVENT_FREEZE handling.
>
> why?
>

I see that my changelog is very cryptic. Sorry about that.

I have been converting drivers from using legacy pm_ops to dev_pm_ops 
which will allow all drivers to use the same infrastructure and overtime 
obsolete the legacy usage. With this change I made, __device_suspend() 
will find  dev->bus->pm->suspend instead of dev->bus->suspend.

isa bus and isa drivers probably will never take advantage of the pm 
capabilities dev_pm_ops allow for, the reason to update the isa bus to 
use dev_pm_ops is to allow for obsoleting legacy pm_ops handling in pm.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
