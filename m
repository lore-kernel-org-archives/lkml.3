Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3JVPDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:03:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab3JVPDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:03:47 -0400
Message-ID: <5266B067.7020207@suse.de>
Date: Tue, 22 Oct 2013 19:05:43 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: vaughan <vaughan.cao@oracle.com>, Steffen Maier <maier@linux.vnet.ibm.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: special sense code asc,ascq=04h,0Ch abort scsi scan
 in the middle
References: <525AD704.6040705@oracle.com> <525BD1EA.6000701@suse.de> <525BE8C1.5090606@linux.vnet.ibm.com> <525BEF2B.2030907@suse.de> <525BF256.6060707@suse.de> <525C0CAE.3030803@linux.vnet.ibm.com> <525E37CA.2000605@suse.de> <5264C48A.80900@oracle.com>
In-Reply-To: <5264C48A.80900@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2013 08:07 AM, vaughan wrote:
> On 10/16/2013 02:52 PM, Hannes Reinecke wrote:
>> But seeing that this approach raises quite some issues I've attached a
>> different patch. Vaughan, could you test with that, too? Should be
>> functionally equivalent to the previous one. Cheers, Hannes
> Hi Hannes,
>
> We only tested the later patch which returns _TARGET_PRESENT after
> parsing sense, it works as expected.
>
> About the cause of this issue, admin said he is configuring a
> active-active cluster mode storage. Each node has it own LUN pool and a
> set of rule to control which node can access the pool.
> LUN7 is owned and can only be able to manipulated by the other node, but
> can be seen by this node for a misconfig. So it presents itself in
> REPORT_LUN but return NOT_READY when accessed through this node.
> Do you still regard this as a misbehave in response to INQUIRY?
>
Yes. INQUIRY _has_ to succeed. The only exceptions here would be devices 
in 'Offline' state.
But other that that, yes, INQUIRY should never abort with an error, 
especially for ALUA.
ALUA relies on 'report target port groups' and INQUIRY EVPD page 0x83 to 
identify the target port group state.
So if INQUIRY does _not_ work you cannot figure out the ALUA state,
and by rights you would need to disable ALUA there.


Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
