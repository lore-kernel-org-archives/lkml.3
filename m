Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192Ab3DJGDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:03:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab3DJGDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:03:06 -0400
Message-ID: <5165008C.1000504@redhat.com>
Date: Wed, 10 Apr 2013 14:02:52 +0800
From: Lingzhu Xiang <lxiang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: matt.fleming@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 3/3] efi: Distinguish between "remaining space" and actually
 used space
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com> <1365561717-12343-3-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1365561717-12343-3-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 10:41 AM, Matthew Garrett wrote:
> +	if (!storage_size || size > remaining_size ||
> +	    ((active_size + size + VAR_METADATA_SIZE > storage_size / 2) &&
> +	     (remaining_size - size - VAR_METADATA_SIZE < storage_size / 2)))

This could overflow.

(u64)32768 - (u64)32768 - VAR_METADATA_SIZE < (u64)65536 / 2 == false
