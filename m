Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab3BAKAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:00:00 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:46205 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756359Ab3BAJ7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:59:55 -0500
Message-ID: <510B9213.1040508@tao.ma>
Date: Fri, 01 Feb 2013 17:59:47 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Bryn M. Reeves" <bmr@redhat.com>
CC: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: How to online remove an error scsi disk from the system?
References: <510B5CFC.2040801@tao.ma> <510B749E.8020501@acm.org> <510B904B.4050508@redhat.com>
In-Reply-To: <510B904B.4050508@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 05:52 PM, Bryn M. Reeves wrote:
> On 02/01/2013 07:54 AM, Bart Van Assche wrote:
>>   * proc_scsi_write - handle writes to /proc/scsi/scsi
>>   * @file: not used
>>   * @buf: buffer to write
>>   * @length: length of buf, at most PAGE_SIZE
>>   * @ppos: not used
>>   *
>>   * Description: this provides a legacy mechanism to add or remove
>>   * devices by Host, Channel, ID, and Lun.  To use,
>>   * "echo 'scsi add-single-device 0 1 2 3' > /proc/scsi/scsi" or
>>   * "echo 'scsi remove-single-device 0 1 2 3' > /proc/scsi/scsi" with
>>   * "0 1 2 3" replaced by the Host, Channel, Id, and Lun.
> 
> The proc interface is deprecated; this can all be done via sysfs today,
> e.g.:
> 
> echo 1 > /sys/block/sdc/device/delete
> 
> Is equivalent to issuing scsi remove-single-device to proc.
yes, but the result is the same. It will do some IO first which will
cause this command hang.

Thanks,
Tao
> 
> Regards,
> Bryn.
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

