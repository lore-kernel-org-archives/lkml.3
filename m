Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbaH0Hic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:38:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbaH0Hib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:38:31 -0400
Message-ID: <53FD8AF1.8010608@suse.com>
Date: Wed, 27 Aug 2014 09:38:25 +0200
From: =?ISO-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Dexuan Cui <decui@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
        "jeremy@goop.org" <jeremy@goop.org>, Jan Beulich <JBeulich@suse.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sync_set_bit() vs set_bit()  -- what's the difference?
References: <EE124450C0AAF944A40DD71E61F878C99639F3@SINEX14MBXC419.southpacific.corp.microsoft.com>
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C99639F3@SINEX14MBXC419.southpacific.corp.microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 09:30 AM, Dexuan Cui wrote:
> I'm curious about the difference. :-)
>
> sync_set_bit() is only used in drivers/hv/ and drivers/xen/ while set_bit() is used in all other places. What makes hv/xen special?

In set_bit() the "lock" prefix will be dropped if only one processor is
present. sync_set_bit() is always attributed with "lock".

xen and hv might require "lock" semantics even if the current OS is
running on only one processor, as syncing with other processors running
other OS's might be necessary.

Juergen

