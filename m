Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaJJFRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 01:17:17 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12222 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaJJFRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 01:17:13 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-c8-54376bd61b82
Message-id: <54376BD5.3000002@samsung.com>
Date: Fri, 10 Oct 2014 07:17:09 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com, andrzej.p@samsung.com,
        m.szyprowski@samsung.com
Subject: Re: [PATCH] usb: gadget: f_fs: remove redundant ffs_data_get()
References: <1412840476-2767-1-git-send-email-r.baldyga@samsung.com>
 <20141009142117.GB16002@saruman>
In-reply-to: <20141009142117.GB16002@saruman>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xa7rXss1DDO6c1bCY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9ktFhxvYXVg99g/dw27x7o/r5g8+rasYvQ4fmM7k8fnTXIB
	rFFcNimpOZllqUX6dglcGVuOPGAumMtR8e1YP3MD4yO2LkZODgkBE4m7U1+wQthiEhfurQeK
	c3EICSxllPi8bTU7hPORUeLnnhvsIFW8AloSE+d3MoPYLAKqEkf2rwaz2QR0JLZ8n8AIYosK
	REicvLsHql5Q4sfkeywgtoiAgMT6F5fAhjILzGeU6Or6CtYgLOAu8fL1ATBbSCBdounSF7Ch
	nAK6Els/7gZq4ABq0JO4f1ELJMwsIC+xec1b5gmMArOQrJiFUDULSdUCRuZVjKKppckFxUnp
	uYZ6xYm5xaV56XrJ+bmbGCEh/mUH4+JjVocYBTgYlXh4L8iYhwixJpYVV+YeYpTgYFYS4dU3
	BQrxpiRWVqUW5ccXleakFh9iZOLglGpgZG12jW4Sk/l3NF75gbv7NXNH3xQ2HxG152te5Aje
	tzV1fT9139Hoa6c//Hl0OpJb4YaDo/3vsoM+U3S9t/NVB/8W1Diq8mKXrWjTjgk5pd42Oh9n
	Vl+O51ec/jHVNT5Va+/p05t01bb/On1L0sjaq2eqRdZcX7e5c/5va99jvSS/m1EqZLugEktx
	RqKhFnNRcSIA2kgfbE8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 04:21 PM, Felipe Balbi wrote:
> On Thu, Oct 09, 2014 at 09:41:16AM +0200, Robert Baldyga wrote:
>> During FunctionFS bind, ffs_data_get() function was called twice
>> (in functionfs_bind() and in ffs_do_functionfs_bind()), while on unbind
>> ffs_data_put() was called once (in functionfs_unbind() function).
>> In result refcount never reached value 0, and ffs memory resources has
>> been never released.
>>
>> Since ffs_data_get() call in ffs_do_functionfs_bind() is redundant
>> and not neccessary, we remove it to have equal number of gets ans puts,
>> and free allocated memory after refcount reach 0.
>>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> 
> Which commit is this fixing ? does it deserve a stable backport ? How
> far back ?
> 

The problem starts with commit 5920cda627688c3229fd63157ff031f3f174175e
[usb: gadget: FunctionFS: convert to new function interface with
backward compatibility].

This bug causes memory leak so I think it should be in stable too.

Thanks,
Robert Baldyga
