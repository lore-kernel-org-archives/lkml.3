Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaGNI6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:58:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbaGNI54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:57:56 -0400
Message-ID: <53C39B91.4010000@suse.de>
Date: Mon, 14 Jul 2014 10:57:53 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com,
        apw@canonical.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, linux-scsi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V3 1/7] Drivers: scsi: storvsc: Change the limits to reflect
 the values on the host
References: <1405183684-23928-1-git-send-email-kys@microsoft.com> <1405183712-23967-1-git-send-email-kys@microsoft.com> <53C37575.5030808@suse.de> <20140714083047.GB22715@infradead.org>
In-Reply-To: <20140714083047.GB22715@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 10:30 AM, Christoph Hellwig wrote:
> On Mon, Jul 14, 2014 at 08:15:17AM +0200, Hannes Reinecke wrote:
>> Limiting max_lun to 255 will make the driver to _not_ respond to LUNs higher
>> than that; ie Well-known LUN won't work here.
>> Also the SCSI stack will be using REPORT LUNS anyway since you're
>> advertising SPC-2 compliance. So your driver runs into issues if Hyper-V
>> would ever return more than 256 LUNs with the REPORT LUN command or if any
>> of the LUNs has an addressing scheme other than
>> '0x00'.
>> I would suggest to raise this to the technical limit (ie the largest LUN
>> which the _protocol_ supports) and let REPORT LUNS deal with the actual
>> LUNs.
>
> I suspect hypverv doesn't support anything more.  For now I'd be
> inclined to just put it in ASAP and if your suggestion works out fix it
> up later, although I'll wait a bit for more review feedback.
>
Okay, that's fine by me.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
