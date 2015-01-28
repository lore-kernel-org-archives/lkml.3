Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbbA2Bbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:31:40 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45379 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbbA2B3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:29:00 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-21-54c88cb7e161
Message-id: <54C88D46.5080803@samsung.com>
Date: Wed, 28 Jan 2015 08:18:30 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers: usb: dwc2: remove 'force' parameter from
 kill_all_requests()
References: <1420450295-25818-1-git-send-email-r.baldyga@samsung.com>
 <1420450295-25818-3-git-send-email-r.baldyga@samsung.com>
 <20150127154232.GE14623@saruman.tx.rr.com>
In-reply-to: <20150127154232.GE14623@saruman.tx.rr.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t/xK7rbe06EGHRu0rI4eL/eonnxejaL
	y7vmsFksWtbKbLF9ynQmB1aP/XPXsHts2f+Z0eP4je1MHp83yQWwRHHZpKTmZJalFunbJXBl
	TJwyna1gO3dFz7yLrA2MCzm7GDk5JARMJCbNPcUKYYtJXLi3nq2LkYtDSGApo8Sbzt9MIAkh
	gY+MEtceB4DYvAJaEpfnfQZrYBFQlfj+8j8LiM0moCOx5fsERhBbVCBC4sOqr2wQ9YISPybf
	A6sRERCQWP/iEjuIzSyQK/H953wwW1ggQaJv900WiMXrGCUuX/sO1sApYC5x7+pj5i5GDqAG
	PYn7F7UgeuUlNq95yzyBUWAWkhWzEKpmIalawMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93
	EyMkhL/uYFx6zOoQowAHoxIPL4PPiRAh1sSy4srcQ4wSHMxKIrxvNYBCvCmJlVWpRfnxRaU5
	qcWHGJk4OKUaGFuL7raGHl7264etSAPHw4K3P25xrG9yeHi1Zg/r65KcJ5dXVv7ZcN00/8H+
	A9vKnjSJnNqjZtqjWsfNLLXohtHLmfF3ZiTm7bJexXeCm/Falsu5xpCNbSsOT+3VeP6t3NeW
	s3rt2yeH3tnMlzdg0Ni+eFXcahkdtzKWh2+Oyr9j+2TEethjzjUlluKMREMt5qLiRAAMwGXI
	PwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2015 04:42 PM, Felipe Balbi wrote:
> On Mon, Jan 05, 2015 at 10:31:35AM +0100, Robert Baldyga wrote:
>> This patch fixes in simpler way the bug described in [1] and [2]. It
>> looks like DWC2 is the only UDC driver that doesn't force usb requests
>> to complete in ep_disable() function. This causes described problem,
>> because we have no guarantee that all requests will be completed before
>> unbind of usb function.
>>
>> To fix this problem we force all requests of disabled endpoint to complete.
>> Also currently running request is not handled. This allowed to simplify
>> code of kill_all_requests() function, because 'force' parameter is always
>> set to true, so we don't need it anymore.
>>
>> In s3c_hsotg_rx_data() we change function used to print message when active
>> request is NULL from dev_warn() to dev_dbg(), because such situation is
>> harmless for driver and now it can take place during normal endpoint
>> disabling.
>>
>> [1] https://lkml.org/lkml/2014/12/9/283
>> [2] https://lkml.org/lkml/2014/12/12/360
>>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> 
> this fails to apply:
> 
> checking file drivers/usb/dwc2/gadget.c
> Hunk #1 succeeded at 2602 (offset 35 lines).
> Hunk #2 FAILED at 2588.
> Hunk #3 succeeded at 2645 (offset 36 lines).
> Hunk #4 FAILED at 2924.
> 2 out of 4 hunks FAILED
> 

Isn't this patch already in linux-next? I see it's also in your 'next'
branch.
