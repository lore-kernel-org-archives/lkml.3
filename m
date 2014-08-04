Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaHDLRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:17:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbaHDLRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:17:20 -0400
Message-ID: <53DF6BBD.2060206@suse.com>
Date: Mon, 04 Aug 2014 13:17:17 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] Save command pool address of Scsi_Host
References: <1407126369-16543-1-git-send-email-jgross@suse.com> <20140804110844.GC19109@infradead.org>
In-Reply-To: <20140804110844.GC19109@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 01:08 PM, Christoph Hellwig wrote:
> On Mon, Aug 04, 2014 at 06:26:09AM +0200, jgross@suse.com wrote:
>> From: Juergen Gross <jgross@suse.com>
>>
>> If a scsi host driver specifies .cmd_len in it's scsi_host_template, a driver's
>> private command pool is needed. scsi_find_host_cmd_pool() will locate it, but
>> scsi_alloc_host_cmd_pool() isn't saving the pool address in the host template.
>>
>> This will result in an access error when the host is removed.
>>
>> Avoid the problem by saving the address of a new allocated command pool where
>> it is expected and delete it again when the pool is destroyed.
>
> I don't really like the double pointer passing - just NULLing out the
> pointer in the caller where needed seems cleaner.

I wanted to avoid to spread this, but I don't mind doing it. V4 is
coming...


Juergen

