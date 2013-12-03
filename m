Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab3LCLSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:18:10 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:58527 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3LCLSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:18:06 -0500
X-IronPort-AV: E=Sophos;i="4.93,817,1378857600"; 
   d="scan'208";a="77672073"
Message-ID: <529DBDEB.7030306@citrix.com>
Date: Tue, 3 Dec 2013 12:18:03 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>,
        <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com> <529DCB3C0200007800109502@nat28.tlf.novell.com>
In-Reply-To: <529DCB3C0200007800109502@nat28.tlf.novell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/13 12:14, Jan Beulich wrote:
>>>> On 03.12.13 at 11:57, Roger Pau Monne <roger.pau@citrix.com> wrote:
>>  struct blkif_request_rw {
>>  	uint8_t        nr_segments;  /* number of segments                   */
>>  	blkif_vdev_t   handle;       /* only for read/write requests         */
>> -#ifdef CONFIG_X86_64
>> -	uint32_t       _pad1;	     /* offsetof(blkif_request,u.rw.id) == 8 */
>> -#endif
>>  	uint64_t       id;           /* private guest value, echoed in resp  */
>>  	blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
>>  	struct blkif_request_segment {
>> @@ -157,47 +154,36 @@ struct blkif_request_rw {
>>  		/* @last_sect: last sector in frame to transfer (inclusive).     */
>>  		uint8_t     first_sect, last_sect;
>>  	} seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>> -} __attribute__((__packed__));
>> +};
> 
> Removing the packed attribute here and below is not possible
> as long as the defined structures get used in struct blkif_request
> as the second field after a uint8_t one, and as long as the
> individual fields here aren't natively aligned.

Sorry, the patch is incorrect, let me resend that.

