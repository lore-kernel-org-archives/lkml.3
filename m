Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3EHCo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:44:58 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:31170
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147Ab3EHCo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:44:56 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT001.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: PS-6(zz98dI936eI1432I13e6Kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Qiaowei Ren <qiaowei.ren@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>
Subject: Re: [PATCH 2/4] driver: provide sysfs interfaces to access TXT
 config space
Thread-Topic: [PATCH 2/4] driver: provide sysfs interfaces to access TXT
 config space
Thread-Index: AQHOSvE/a+ghBFBXCUi0/GPSGvVi2pj6liGA
Date: Wed, 8 May 2013 02:44:50 +0000
Message-ID: <1367981089.2425.18.camel@x230>
References: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
	 <1367938519-840-3-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1367938519-840-3-git-send-email-qiaowei.ren@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A26D3EAD3F3FED48A3EF429A14366771@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r482j4WJ006789

On Tue, 2013-05-07 at 22:55 +0800, Qiaowei Ren wrote:

> +		Registers in the private space can only be accessed after a
> +		measured environment has been established and before the
> +		TXT.CMD.CLOSE-PRIVATE command has been issued. 

Is userspace ever going to be running in this situation?

> +What:		/sys/devices/platform/intel_txt/config/STS_raw
> +Date:		May 2013
> +KernelVersion:	3.9
> +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> +Description:	TXT.STS is the general status register. This read-only register
> +		is used by AC modules and the MLE to get the status of various
> +		Intel TXT features.

AC? MLE?

> +What:		/sys/devices/platform/intel_txt/config/STS_enter_done
> +Date:		May 2013
> +KernelVersion:	3.9
> +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> +Description:	The chipset sets SENTER.DONE.STS status bit when it sees all
> +		of the threads have done an TXT.CYC.SENTER-ACK.

All of which threads? It might be worth adding a general introduction to
TXT in Documentation and referencing it in these entries.

> +What:		/sys/devices/platform/intel_txt/config/STS_sexit_done
> +Date:		May 2013
> +KernelVersion:	3.9
> +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> +Description:	SEXIT.DONE.STS status bit is set when all of the bits in the
> +		TXT.THREADS.JOIN register are clear. Thus, this bit will be
> +		set immediately after reset.

It will? When will it be clear? What would userspace ever want this for?

> +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> +Description:	TXT.SINIT.BASE register contains the physical base address
> +		of the memory region set aside by the BIOS for loading an
> +		SINIT AC module. If BIOS has provided an SINIT AC module,
> +		it will be located at this address. System software that
> +		provides an SINIT AC module must store it to this location.

Why would userspace ever care about this?

> +What:		/sys/devices/platform/intel_txt/config/SINIT_SIZE
> +Date:		May 2013
> +KernelVersion:	3.9
> +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> +Description:	TXT.SINIT.SIZE register contains the size (in bytes) of
> +		the memory region set aside by the BIOS for loading an
> +		SINIT AC module. This register is initialized by the BIOS.

Or this?

> +What:		/sys/devices/platform/intel_txt/config/MLE_JOIN
> +Date:		May 2013
> +KernelVersion:	3.9
> +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> +Description:	Holds a physical address pointer to the base of the join
> +		data structure used to initialize RLPs in response to
> +		GETSEC[WAKEUP].

RLPs?

> +What:		/sys/devices/platform/intel_txt/config/HEAP_BASE
> +Date:		May 2013
> +KernelVersion:	3.9
> +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> +Description:	TXT.HEAP.BASE register contains the physical base address
> +		of the Intel TXT Heap memory region. The BIOS initializes
> +		this register.

Again, it doesn't seem obvious why userspace would ever want this...

> +What:		/sys/devices/platform/intel_txt/config/HEAP_SIZE
> +Date:		May 2013
> +KernelVersion:	3.9
> +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> +Description:	TXT.HEAP.SIZE register contains the size (in bytes) of the
> +		Intel TXT Heap memory region. The BIOS initializes this
> +		register.

Or this.

Basically, don't just define what these files do - make it clear why
they'd be used. Right now I have no idea whether these are diagnostic,
likely to be used during runtime or basically completely useless.

> +static ssize_t txt_show_ERRORCODE(struct device *dev,
> +				  struct device_attribute *attr, char *buf)
> +{
> +	return show_config(buf, off_ERRORCODE);
> +}

Much as I usually hate it, these all seem pretty boilerplate. It would
arguably be cleaner to replace them all with something like:

#define config_func(x) static size_t txt_show_x(struct device *dev,
struct device_attribute *attr, char *buf) { return show_config(buf
off_x);}\ntxt_store_x(struct device *dev, struct device_attribute *attr,
const char *buf, size_t count) { blah blah

config_func(ERRORCODE)
config_func(ESTS_raw)

and so on.

> +int sysfs_create_config(struct kobject *parent)
> +{
> +	return sysfs_create_group(parent, &config_attr_grp);
> +}
> +EXPORT_SYMBOL_GPL(sysfs_create_config);

This doesn't seem right. You're linking this into the existing txt
module - you don't need to export symbols.

> +MODULE_LICENSE("GPL");

Or declare a module license.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
