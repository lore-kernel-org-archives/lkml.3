Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964972AbaDITx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:53:57 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:35652 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934006AbaDITxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:53:50 -0400
Message-ID: <5345A54D.2050808@akamai.com>
Date: Wed, 09 Apr 2014 15:53:49 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "Luck, Tony" <tony.luck@intel.com>, Aristeu Rozanski <aris@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ie31200_edac: Add driver
References: <cover.1396645124.git.jbaron@akamai.com> <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com> <20140409113552.GJ6529@pd.tnic> <20140409133433.GJ29214@redhat.com> <3908561D78D1C84285E8C5FCA982C28F31E22EAC@ORSMSX106.amr.corp.intel.com> <20140409173633.GN6529@pd.tnic> <5345980F.7070604@akamai.com> <20140409191454.GQ6529@pd.tnic>
In-Reply-To: <20140409191454.GQ6529@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 03:14 PM, Borislav Petkov wrote:
> On Wed, Apr 09, 2014 at 02:57:19PM -0400, Jason Baron wrote:
>> Right, so maybe the fact that its a desktop chipset means that it
>> behaves differently and doesn't raise MCEs on memory errors. We have a
>> bunch of these processors and we haven't yet seen an MCE raised on a
>> memory error.
> 
> This can't be - an uncorrectable error will have to generate a machine
> check exception if consumed - there's no other option.
> 
> Can you do
> 
> rdmsr 0x179
> rdmsr 0x17b
> 
> and paste the results here?
>

Unfortunately, the box reporting the ue errors just went into transit (so
that I can better examine this issue), so I will probably not be able to
run this experiment on that specific box until next week.

However, I was able to run it on a very similar box (same pci id for the
mch), and I get:
 
# ./rdmsr 0x179
c09

# ./rdmsr 0x17b
rdmsr: CPU 0 cannot read MSR 0x0000017b

Thanks,

-Jason
