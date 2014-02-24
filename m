Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaBXTJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:09:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39969 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaBXTI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:08:59 -0500
Message-ID: <530B989B.8010507@zytor.com>
Date: Mon, 24 Feb 2014 11:08:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
CC: ebiederm@xmission.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz
Subject: Re: [PATCH 07/11] kexec: Create a relocatable object called purgatory
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com> <1390849071-21989-8-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1390849071-21989-8-git-send-email-vgoyal@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 10:57 AM, Vivek Goyal wrote:
> +
> +/**
> + * memcpy - Copy one area of memory to another
> + * @dest: Where to copy to
> + * @src: Where to copy from
> + * @count: The size of the area.
> + */
> +static void *memcpy(void *dest, const void *src, unsigned long count)
> +{
> +	char *tmp = dest;
> +	const char *s = src;
> +
> +	while (count--)
> +		*tmp++ = *s++;
> +	return dest;
> +}
> +
> +static int memcmp(const void *cs, const void *ct, size_t count)
> +{
> +	const unsigned char *su1, *su2;
> +	int res = 0;
> +
> +	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--)
> +		if ((res = *su1 - *su2) != 0)
> +			break;
> +	return res;
> +}
> +

<bikeshed>

There multiple implementations of memcpy(), memcmp() and memset() in
this patchset, and they make my eyes want to bleed (especially
memcmp()).  Can we centralize there, and perhaps even share code with
the stuff in arch/x86/boot already?

</bikeshed>

	-hpa

