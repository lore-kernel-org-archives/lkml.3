Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763486AbbA2DAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:00:22 -0500
Received: from mail-by2on0055.outbound.protection.outlook.com ([207.46.100.55]:61120
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756518AbbA2DAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 22:00:17 -0500
X-Greylist: delayed 21654 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jan 2015 22:00:17 EST
X-AuditID: ac160a69-f79956d000002b3c-f3-54c8aaac063a
Message-ID: <54C8AAA9.7060300@sandisk.com>
Date: Wed, 28 Jan 2015 10:23:53 +0100
From: Bart Van Assche <bart.vanassche@sandisk.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@infradead.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: module: fix module_refcount() return when running in a module
 exit routine
References: <1421600146.2080.8.camel@HansenPartnership.com>
	 <54BC93C3.7010808@hitachi.com> <878ugzco8c.fsf@rustcorp.com.au>
	 <1421683701.2080.25.camel@HansenPartnership.com>
	 <871tmqcmau.fsf@rustcorp.com.au>
	 <1421774615.2080.88.camel@HansenPartnership.com>
	 <20150122165018.GA27377@infradead.org>
	 <1421946175.2093.1.camel@HansenPartnership.com>
	 <87iofyurzc.fsf@rustcorp.com.au> <20150123131758.GC8045@infradead.org>
 <1422038567.2126.14.camel@HansenPartnership.com>
In-Reply-To: <1422038567.2126.14.camel@HansenPartnership.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI8azSHfNqhMhBu8/SFicnrCIyWJjP4fF
	5V1z2Cy6r+9gs1i/dw2Txc1pF1gc2DymTTrF5tF6Zg2Lx+YVWh4rNpxg9vi8SS6ANYrLJiU1
	J7MstUjfLoEr4/TaX2wFe/Qr/i/namB8odrFyMkhIWAicb/rCxuELSZx4d56IJuLQ0jgBKPE
	oRsTGCGcHYwS185NZIXpOL5qOytEYgujxM4FnWDtvAJaEn1vf4PZLAKqEs+P3gaz2QSMJL69
	n8kCYosKhEl837yDGaJeUOLkzCdgcRGBFIm1bXPAhjILbGeU+Pl5Idg2YYFIic2f1kBtu8Is
	se38F0aQBKeArcSpd+eAJnEAdWhKrN+lDxJmFpCX2P52DjPEpSdZJRYfdQCxhQTUJU4umc80
	gVFkFpLdsxC6ZyHpXsDIvIpRLDczpzg3PbXA0EivODEvJbM4Wy85P3cTIzh2uDJ3MK6YZH6I
	UYCDUYmHNyPmRIgQa2JZcWXuIUYJDmYlEd74aUAh3pTEyqrUovz4otKc1OJDjNIcLErivILT
	s/yFBNITS1KzU1MLUotgskwcnFINjFHTDzZ1LBMsWBl65s6H6S7n1H8vuVlxWnR5Z94i1Vkc
	hWnXzE+VLD//55CXVkxR/c11j+LXRtnNEPe4+/PC0XpL/yd8CuKrGNewrlvRzfVf4LOSV/dr
	ljs6LTu1Td7zivzZaZ9/a+XvpvBivw+dr3kttbYeLH/HdbLAf7n7559xJ2Te5PAuaVBiKc5I
	NNRiLipOBAA++W1VmQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsXCtZEjRXfNqhMhBm9+cVicnrCIyWJjP4fF
	5V1z2Cy6r+9gs1i/dw2Txc1pF1gc2DymTTrF5tF6Zg2Lx+YVWh4rNpxg9vi8SS6ANYrLJiU1
	J7MstUjfLoEr4/TaX2wFe/Qr/i/namB8odrFyMkhIWAicXzVdlYIW0ziwr31bF2MXBxCApsY
	JWZ+WMIOkuAV0JLoe/ubDcRmEVCVeH70NpjNJmAk8e39TBYQW1QgTOL75h3MEPWCEidnPgGL
	iwikSlxZ/RZsKLPAbkaJV0s2gjULC0RKbP60hhVi2xVmiW3nvzCCJDgFbCVOvTsHNolZQF3i
	z7xLULa8xPa3c5gnMPLPQrJkFpKyWUjKFjAyr2IUy83MKc5NzywwNNQrTsxLySzO1kvOz93E
	CA5hzsgdjE8nmh9iZOLglGpgDIviz2fMmuSg/f2J4/Z4B+mrjz3c32Spbmhoqf+R5ewl9fri
	XF+pfuOredFTM1QaBR75eJiZlDUahR86djUm8UIWh22s1S6LeRJuyw7bBHvelLzkePNR1bsD
	YlNe2v0TWTTD9d5sdsEZjQL+l8+2sfk2Xp6cfd9DbH6DwtxbEU9a2QQeP7+ixFKckWioxVxU
	nAgA8pFmshECAAA=
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 63.163.107.173)
 smtp.mailfrom=Bart.VanAssche@sandisk.com; vger.kernel.org; dkim=none (message
 not signed) header.d=none;vger.kernel.org; dmarc=permerror action=none
 header.from=sandisk.com;
X-Forefront-Antispam-Report: CIP:63.163.107.173;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(51704005)(164054003)(479174004)(24454002)(80316001)(87266999)(64126003)(86362001)(47776003)(50466002)(65956001)(65816999)(93886004)(76176999)(50986999)(23676002)(65806001)(54356999)(59896002)(87936001)(33656002)(83506001)(46102003)(36756003)(77096005)(62966003)(77156002)(92566002)(2950100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR02MB123;H:milsmgep12.sandisk.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR02MB123;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR02MB123;
X-Forefront-PRVS: 047001DADA
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB123;
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2015 09:23:58.1088
 (UTC)
X-MS-Exchange-CrossTenant-Id: fcd9ea9c-ae8c-460c-ab3c-3db42d7ac64d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fcd9ea9c-ae8c-460c-ab3c-3db42d7ac64d;Ip=[63.163.107.173]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR02MB123
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/15 19:42, James Bottomley wrote:
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 08c90a7..31ba254 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -965,6 +965,15 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
>  }
>  EXPORT_SYMBOL(scsi_report_opcode);
>  
> +static int __scsi_device_get_common(struct scsi_device *sdev)
> +{
> +	if (sdev->sdev_state == SDEV_DEL)
> +		return -ENXIO;
> +	if (!get_device(&sdev->sdev_gendev))
> +		return -ENXIO;
> +	return 0;
> +}
> +
>  /**
>   * scsi_device_get  -  get an additional reference to a scsi_device
>   * @sdev:	device to get a reference to
> @@ -975,19 +984,45 @@ EXPORT_SYMBOL(scsi_report_opcode);
>   */
>  int scsi_device_get(struct scsi_device *sdev)
>  {
> -	if (sdev->sdev_state == SDEV_DEL)
> -		return -ENXIO;
> -	if (!get_device(&sdev->sdev_gendev))
> -		return -ENXIO;
> -	/* We can fail this if we're doing SCSI operations
> -	 * from module exit (like cache flush) */
> -	try_module_get(sdev->host->hostt->module);
> +	int ret;
>  
> -	return 0;
> +	ret = __scsi_device_get_common(sdev);
> +	if (ret)
> +		return ret;
> +
> +	ret = try_module_get(sdev->host->hostt->module);
> +
> +	if (ret)
> +		put_device(&sdev->sdev_gendev);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL(scsi_device_get);
>  
>  /**
> + * scsi_device_get_in_module_exit() - get an additional reference to a scsi_device
> + * @sdev:	device to get a reference to
> + *
> + * Functions identically to scsi_device_get() except that it unconditionally
> + * gets the module reference.  This allows it to be called from module exit
> + * routines where scsi_device_get() will fail.  This routine is still paired
> + * with scsi_device_put().
> + */
> +int scsi_device_get_in_module_exit(struct scsi_device *sdev)
> +{
> +	int ret;
> +
> +	ret = __scsi_device_get_common(sdev);
> +	if (ret)
> +		return ret;
> +
> +	__module_get(sdev->host->hostt->module);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(scsi_device_get_in_module_exit);
> +
> +/**
>   * scsi_device_put  -  release a reference to a scsi_device
>   * @sdev:	device to release a reference on.
>   *
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index ebf35cb6..057604e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -564,16 +564,22 @@ static int sd_major(int major_idx)
>  	}
>  }
>  
> -static struct scsi_disk *__scsi_disk_get(struct gendisk *disk)
> +static struct scsi_disk *__scsi_disk_get(struct gendisk *disk, int in_exit)
>  {
>  	struct scsi_disk *sdkp = NULL;
>  
>  	if (disk->private_data) {
> +		int ret;
> +
>  		sdkp = scsi_disk(disk);
> -		if (scsi_device_get(sdkp->device) == 0)
> -			get_device(&sdkp->dev);
> +		if (in_exit)
> +			ret = scsi_device_get_in_module_exit(sdkp->device);
>  		else
> +			ret = scsi_device_get(sdkp->device);
> +		if (unlikely(ret))
>  			sdkp = NULL;
> +		else
> +			get_device(&sdkp->dev);
>  	}
>  	return sdkp;
>  }
> @@ -583,19 +589,19 @@ static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
>  	struct scsi_disk *sdkp;
>  
>  	mutex_lock(&sd_ref_mutex);
> -	sdkp = __scsi_disk_get(disk);
> +	sdkp = __scsi_disk_get(disk, 0);
>  	mutex_unlock(&sd_ref_mutex);
>  	return sdkp;
>  }
>  
> -static struct scsi_disk *scsi_disk_get_from_dev(struct device *dev)
> +static struct scsi_disk *scsi_disk_get_from_dev(struct device *dev, int in_exit)
>  {
>  	struct scsi_disk *sdkp;
>  
>  	mutex_lock(&sd_ref_mutex);
>  	sdkp = dev_get_drvdata(dev);
>  	if (sdkp)
> -		sdkp = __scsi_disk_get(sdkp->disk);
> +		sdkp = __scsi_disk_get(sdkp->disk, in_exit);
>  	mutex_unlock(&sd_ref_mutex);
>  	return sdkp;
>  }
> @@ -1525,7 +1531,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>  
>  static void sd_rescan(struct device *dev)
>  {
> -	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
> +	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, 0);
>  
>  	if (sdkp) {
>  		revalidate_disk(sdkp->disk);
> @@ -3147,7 +3153,7 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>   */
>  static void sd_shutdown(struct device *dev)
>  {
> -	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
> +	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, 1);
>  
>  	if (!sdkp)
>  		return;         /* this can happen */
> @@ -3171,7 +3177,7 @@ exit:
>  
>  static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
>  {
> -	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
> +	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, 0);
>  	int ret = 0;
>  
>  	if (!sdkp)
> @@ -3213,7 +3219,7 @@ static int sd_suspend_runtime(struct device *dev)
>  
>  static int sd_resume(struct device *dev)
>  {
> -	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
> +	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, 0);
>  	int ret = 0;
>  
>  	if (!sdkp->device->manage_start_stop)
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 2e0281e..0bad37c 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -327,6 +327,7 @@ extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
>  void scsi_attach_vpd(struct scsi_device *sdev);
>  
>  extern int scsi_device_get(struct scsi_device *);
> +extern int scsi_device_get_in_module_exit(struct scsi_device *);
>  extern void scsi_device_put(struct scsi_device *);
>  extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
>  					      uint, uint, u64);

Hello James,

Is this the latest version of this patch that is available ? I have
tried to test the above patch. However, I couldn't test the impact of
this patch on the SRP initiator driver since my test system didn't boot
anymore with the above patch applied. That test system boots from an ATA
disk managed by the SCSI subsystem:
$ lsscsi | head -n1
[0:0:0:0]    disk    ATA      KINGSTON SH103S3 BBF0  /dev/sda

Thanks,

Bart.
