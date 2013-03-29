Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3C2DwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 23:52:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:9073 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab3C2DwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 23:52:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,370,1363104000"; 
   d="scan'208";a="6966867"
Message-ID: <51550F8B.1000402@cn.fujitsu.com>
Date: Fri, 29 Mar 2013 11:50:35 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, vgoyal@redhat.com,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sysfs: Add crash_notes_size to export percpu note
 size
References: <5153FC27.70001@cn.fujitsu.com>
In-Reply-To: <5153FC27.70001@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/29 11:51:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/29 11:51:16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, simon

I forgot to add your email in the CC, could you please help
reviewing this patch since I will send the kexec-tools patch
if this patch is accepted.

Thanks
Zhang

于 2013年03月28日 16:15, Zhang Yanfei 写道:
> For percpu notes, we are exporting only address and not size. So
> the userspace tool kexec-tools is putting an upper limit of 1024
> and putting the value in p_memsz and p_filesz fields. So the patch
> add the new sysfile crash_notes_size to export the exact percpu
> note size and let the kexec-tools parse it intead of using 1024.
> 
> The idea came from Vivek Goyal. And a later patch will be sent to
> kexec-tools to let it parse the size.
> 
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  drivers/base/cpu.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index fb10728..a55b590 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -132,6 +132,17 @@ static ssize_t show_crash_notes(struct device *dev, struct device_attribute *att
>  	return rc;
>  }
>  static DEVICE_ATTR(crash_notes, 0400, show_crash_notes, NULL);
> +
> +static ssize_t show_crash_notes_size(struct device *dev,
> +				     struct device_attribute *attr,
> +				     char *buf)
> +{
> +	ssize_t rc;
> +
> +	rc = sprintf(buf, "%lu\n", sizeof(note_buf_t));
> +	return rc;
> +}
> +static DEVICE_ATTR(crash_notes_size, 0400, show_crash_notes_size, NULL);
>  #endif
>  
>  /*
> @@ -259,6 +270,9 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
>  #ifdef CONFIG_KEXEC
>  	if (!error)
>  		error = device_create_file(&cpu->dev, &dev_attr_crash_notes);
> +	if (!error)
> +		error = device_create_file(&cpu->dev,
> +					   &dev_attr_crash_notes_size);
>  #endif
>  	return error;
>  }

