Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3BAKHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:07:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab3BAKHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:07:48 -0500
Message-ID: <510B93EE.8000304@redhat.com>
Date: Fri, 01 Feb 2013 10:07:42 +0000
From: "Bryn M. Reeves" <bmr@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: How to online remove an error scsi disk from the system?
References: <510B5CFC.2040801@tao.ma> <510B749E.8020501@acm.org> <510B904B.4050508@redhat.com> <510B9213.1040508@tao.ma>
In-Reply-To: <510B9213.1040508@tao.ma>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 09:59 AM, Tao Ma wrote:
> yes, but the result is the same. It will do some IO first which will
> cause this command hang.

You seem to have a problem with either the device/adapter or in the 
driver. The backtrace you posted shows that jbd2 (ext4) is still waiting 
on IO that's been submitted to an mpt2sas or mpt3sas adapter (I only 
know that because I recognise their log messages - you should try to 
include relevant details like this when seeking assistance).

The adapter/driver hasn't completed the IO and it looks like the SCSI 
layer is trying to abort it. Depending on the state of the driver and 
hardware your only option might be to reboot (or physically hot remove 
the device if your hardware allows it).

You don't mention the versions of the kernel and driver you're using - 
if the system is in production I would suggest contacting who ever 
normally provides support for the kernel and distribution that you are 
running.

Regards,
Bryn.

