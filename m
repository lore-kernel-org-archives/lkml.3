Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaFXKNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:13:38 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:32924 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaFXKNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:13:37 -0400
Message-ID: <53A94F4D.10605@imgtec.com>
Date: Tue, 24 Jun 2014 11:13:33 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Daniel Walter <dwalter@google.com>, Ralf Baechle <ralf@linux-mips.org>
CC: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arch/mips rb532: replace mac_addr parsing
References: <20140624084540.GA22930@google.com>
In-Reply-To: <20140624084540.GA22930@google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 24/06/14 09:45, Daniel Walter wrote:
> @@ -333,7 +311,13 @@ static int __init plat_setup_devices(void)
>  static int __init setup_kmac(char *s)
>  {
>  	printk(KERN_INFO "korina mac = %s\n", s);
> -	parse_mac_addr(s);
> +	sscanf(s, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx",
> +			&korina_dev0_data.mac[0],
> +			&korina_dev0_data.mac[1],
> +			&korina_dev0_data.mac[2],
> +			&korina_dev0_data.mac[3],
> +			&korina_dev0_data.mac[4],
> +			&korina_dev0_data.mac[5]);

Does it make sense to go one better and use mac_pton() for this?

Cheers
James
