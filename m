Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3JCTwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:52:14 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64782 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab3JCTwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:52:13 -0400
Message-ID: <524DCAE6.5090601@gmail.com>
Date: Thu, 03 Oct 2013 14:52:06 -0500
From: Tom Musta <tommusta@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Michael Ellerman <michael@ellerman.id.au>,
        Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/9][v5] powerpc: implement is_instr_load_store().
References: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com> <1380672911-12812-6-git-send-email-sukadev@linux.vnet.ibm.com> <20131003053519.GC17237@concordia> <20131003190325.GB21561@us.ibm.com>
In-Reply-To: <20131003190325.GB21561@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/2013 2:03 PM, Sukadev Bhattiprolu wrote:
> Michael Ellerman [michael@ellerman.id.au] wrote:
<snip>
> |
> |         if (lower == 6)
> |             if (upper <= 1)
> |                 return true;
> |             return false;
> v
Note that this case covers the lvsl/lvsr instructions, which, despite their
names are not actually loads.  So you could eliminate this check and do
just a little bit better.
