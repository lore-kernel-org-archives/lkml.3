Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab3BAJwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:52:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235Ab3BAJwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:52:17 -0500
Message-ID: <510B904B.4050508@redhat.com>
Date: Fri, 01 Feb 2013 09:52:11 +0000
From: "Bryn M. Reeves" <bmr@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Tao Ma <tm@tao.ma>, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: How to online remove an error scsi disk from the system?
References: <510B5CFC.2040801@tao.ma> <510B749E.8020501@acm.org>
In-Reply-To: <510B749E.8020501@acm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 07:54 AM, Bart Van Assche wrote:
>   * proc_scsi_write - handle writes to /proc/scsi/scsi
>   * @file: not used
>   * @buf: buffer to write
>   * @length: length of buf, at most PAGE_SIZE
>   * @ppos: not used
>   *
>   * Description: this provides a legacy mechanism to add or remove
>   * devices by Host, Channel, ID, and Lun.  To use,
>   * "echo 'scsi add-single-device 0 1 2 3' > /proc/scsi/scsi" or
>   * "echo 'scsi remove-single-device 0 1 2 3' > /proc/scsi/scsi" with
>   * "0 1 2 3" replaced by the Host, Channel, Id, and Lun.

The proc interface is deprecated; this can all be done via sysfs today, 
e.g.:

echo 1 > /sys/block/sdc/device/delete

Is equivalent to issuing scsi remove-single-device to proc.

Regards,
Bryn.


