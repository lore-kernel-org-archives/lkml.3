Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab3KFXur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 18:50:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:32213 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab3KFXuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 18:50:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="430993340"
Message-ID: <527AD5A2.70902@intel.com>
Date: Wed, 06 Nov 2013 15:49:54 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] mm: allow to set overcommit ratio more precisely
References: <1382101019-23563-1-git-send-email-jmarchan@redhat.com>	<1382101019-23563-2-git-send-email-jmarchan@redhat.com>	<20131105155319.732dcbefb162c2ee4716ef9d@linux-foundation.org>	<1450211196.19341043.1383727340985.JavaMail.root@redhat.com> <20131106143313.1a368250df917fba0faf56fe@linux-foundation.org>
In-Reply-To: <20131106143313.1a368250df917fba0faf56fe@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 02:33 PM, Andrew Morton wrote:
> On Wed, 6 Nov 2013 03:42:20 -0500 (EST) Jerome Marchand <jmarchan@redhat.com> wrote:
>> That was my first version of this patch (actually "kbytes" to avoid
>> overflow).
>> Dave raised the issue that it silently breaks the user interface:
>> overcommit_ratio is zero while the system behaves differently.
> 
> I don't understand that at all.  We keep overcommit_ratio as-is, with
> the same default values and add a different way of altering it.  That
> should be back-compatible?

Reading the old thread, I think my main point was that we shouldn't
output overcommit_ratio=0 when overcommit_bytes>0.  We need to round up
for numbers less than 1 so that folks don't think overcommit_ratio is _off_.

I was really just trying to talk you in to cramming the extra precision
in to the _existing_ sysctl. :)  I don't think bytes vs. ratio is really
that big of a deal.
