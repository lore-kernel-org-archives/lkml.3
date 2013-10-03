Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab3JCONU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:13:20 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:21282
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751628Ab3JCONS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:13:18 -0400
From: KY Srinivasan <kys@microsoft.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Jack Wang <xjtuwjp@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: Drivers: scsi: FLUSH timeout
Thread-Topic: Drivers: scsi: FLUSH timeout
Thread-Index: AQHOtkBtWGcmfS/7wkmW+8Ppp9OK8pnPmBJggAU49YCAAAdE0IAAT/uAgABKyICAALYxAIALo8YggAEpLYCAABxw8A==
Date: Thu, 3 Oct 2013 14:13:13 +0000
Message-ID: <b1a04eb5b007455f9b57467b9c87ddf5@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
	 <20130920203222.GA14306@kroah.com>
	 <a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com>
	 <524180B7.7090307@gmail.com>
	 <3413dbd7fa254fd380a84fe6d9cd87e1@SN2PR03MB061.namprd03.prod.outlook.com>
	 <5241C9E7.2000404@cs.wisc.edu>
	 <bf168ab724a140f989ab3dfe877b750f@SN2PR03MB061.namprd03.prod.outlook.com>
	 <CAMuHMdV-BsKc-c1YhzqFrUGJhw+jMZEXXTcT2xyDLnw-JQuVaQ@mail.gmail.com>
	 <ff6a93ed5d234c14874d03415812a3ec@SN2PR03MB061.namprd03.prod.outlook.com>
 <1380802143.19256.95.camel@haakon3.risingtidesystems.com>
In-Reply-To: <1380802143.19256.95.camel@haakon3.risingtidesystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.61.203.63]
x-forefront-prvs: 09888BC01D
x-forefront-antispam-report: SFV:NSPM;SFS:(13464003)(51704005)(24454002)(377454003)(377424004)(199002)(189002)(80022001)(83072001)(65816001)(63696002)(59766001)(77982001)(81542001)(54316002)(49866001)(56776001)(81342001)(50986001)(47976001)(47736001)(85306002)(80976001)(33646001)(74316001)(74366001)(19580405001)(53806001)(4396001)(19580395003)(79102001)(69226001)(56816003)(77096001)(76786001)(47446002)(76796001)(74502001)(74662001)(31966008)(76482001)(54356001)(76576001)(74876001)(83322001)(66066001)(74706001)(81686001)(81816001)(46102001)(51856001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:174.61.203.63;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r93EDXIg004317



> -----Original Message-----
> From: Nicholas A. Bellinger [mailto:nab@linux-iscsi.org]
> Sent: Thursday, October 03, 2013 5:09 AM
> To: KY Srinivasan
> Cc: Geert Uytterhoeven; Mike Christie; Jack Wang; Greg KH; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: Re: Drivers: scsi: FLUSH timeout
> 
> On Wed, 2013-10-02 at 18:29 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: geert.uytterhoeven@gmail.com
> [mailto:geert.uytterhoeven@gmail.com]
> > > On Behalf Of Geert Uytterhoeven
> > > Sent: Wednesday, September 25, 2013 1:40 AM
> > > To: KY Srinivasan
> > > Cc: Mike Christie; Jack Wang; Greg KH; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com;
> > > hch@infradead.org; linux-scsi@vger.kernel.org
> > > Subject: Re: Drivers: scsi: FLUSH timeout
> > >
> > > On Tue, Sep 24, 2013 at 11:53 PM, KY Srinivasan <kys@microsoft.com> wrote:
> > > > I am not sure how that magic number was arrived at (the 60HZ number). We
> > > want this to be little higher -
> > >
> > > "60 * HZ" means "60 seconds".
> > >
> > > > would there be any issues raising this to say  180 seconds. This is the value
> we
> > > currently have for I/O
> > > > timeout.
> > >
> > > So you want to replace it by "180 * HZ", which is ... another magic number?
> >
> > Ideally, I want this to be adjustable like the way we can change the I/O timeout.
> > Since that has been attempted earlier and rejected (not clear what the reasons
> were),
> > I was suggesting that we pick a larger number. James, let me know how I should
> proceed here.
> >
> 
> I think the objection was to making a module parameter for doing this
> globally for all struct scsi_disk, and not the idea of making it
> adjustable on an individual basis per-say..
> 
> What about adding a /sys/class/scsi_disk/$HCTL/flush_timeout..?
> 
> Here's a quick (untested) patch to that effect.

Thanks Nicholas. This is precisely what I was hoping we could agree on. 
James, if this is acceptable, we will go ahead and test this patch.


Regards,

K. Y
> 
> --nab
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index e62d17d..f7a8c5b 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -460,6 +460,38 @@ max_write_same_blocks_store(struct device *dev,
> struct device_attribute *attr,
>  }
>  static DEVICE_ATTR_RW(max_write_same_blocks);
> 
> +static ssize_t
> +flush_timeout_show(struct device *dev,
> +		   struct device_attribute *attr, char *buf)
> +{
> +	struct scsi_disk *sdkp = to_scsi_disk(dev);
> +
> +	return snprintf(buf, 20, "%u\n", sdkp->flush_timeout);
> +}
> +
> +static ssize_t
> +flush_timeout_store(struct device *dev,
> +		    struct device_attribute *attr, const char *buf,
> +		    size_t count)
> +{
> +	struct scsi_disk *sdkp = to_scsi_disk(dev);
> +	unsigned int flush_timeout;
> +	int err;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +
> +	err = kstrtouint(buf, 10, &flush_timeout);
> +
> +	if (flush_timeout > SD_FLUSH_TIMEOUT_MAX)
> +		return -EINVAL;
> +
> +	sdkp->flush_timeout = flush_timeout;
> +
> +	return err ? err : count;
> +}
> +static DEVICE_ATTR_RW(flush_timeout);
> +
>  static struct attribute *sd_disk_attrs[] = {
>  	&dev_attr_cache_type.attr,
>  	&dev_attr_FUA.attr,
> @@ -472,6 +504,7 @@ static struct attribute *sd_disk_attrs[] = {
>  	&dev_attr_provisioning_mode.attr,
>  	&dev_attr_max_write_same_blocks.attr,
>  	&dev_attr_max_medium_access_timeouts.attr,
> +	&dev_attr_flush_timeout.attr,
>  	NULL,
>  };
>  ATTRIBUTE_GROUPS(sd_disk);
> @@ -829,7 +862,9 @@ static int sd_setup_write_same_cmnd(struct scsi_device
> *sdp, struct request *rq)
> 
>  static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
>  {
> -	rq->timeout = SD_FLUSH_TIMEOUT;
> +	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
> +
> +	rq->timeout = sdkp->flush_timeout;
>  	rq->retries = SD_MAX_RETRIES;
>  	rq->cmd[0] = SYNCHRONIZE_CACHE;
>  	rq->cmd_len = 10;
> @@ -2841,6 +2876,7 @@ static void sd_probe_async(void *data, async_cookie_t
> cookie)
>  	sdkp->ATO = 0;
>  	sdkp->first_scan = 1;
>  	sdkp->max_medium_access_timeouts = SD_MAX_MEDIUM_TIMEOUTS;
> +	sdkp->flush_timeout = SD_FLUSH_TIMEOUT;
> 
>  	sd_revalidate_disk(gd);
> 
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 7a049de..ac7cd0f 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -14,6 +14,7 @@
>  #define SD_TIMEOUT		(30 * HZ)
>  #define SD_MOD_TIMEOUT		(75 * HZ)
>  #define SD_FLUSH_TIMEOUT	(60 * HZ)
> +#define SD_FLUSH_TIMEOUT_MAX	(180 * HZ)
>  #define SD_WRITE_SAME_TIMEOUT	(120 * HZ)
> 
>  /*
> @@ -68,6 +69,7 @@ struct scsi_disk {
>  	unsigned int	physical_block_size;
>  	unsigned int	max_medium_access_timeouts;
>  	unsigned int	medium_access_timed_out;
> +	unsigned int	flush_timeout;
>  	u8		media_present;
>  	u8		write_prot;
>  	u8		protection_type;/* Data Integrity Field */

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
