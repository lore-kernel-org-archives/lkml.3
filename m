Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbaDHPKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:10:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757065AbaDHPKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:10:02 -0400
Message-ID: <53441149.8010902@suse.cz>
Date: Tue, 08 Apr 2014 17:10:01 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>, Christian Engelmayer <cengelma@gmx.at>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] modpost: Fix ressource leak in read_dump()
References: <20140406003649.1ba3c993@spike> <20140406000512.GS32556@tassilo.jf.intel.com>
In-Reply-To: <20140406000512.GS32556@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-06 02:05, Andi Kleen wrote:
> On Sun, Apr 06, 2014 at 12:36:49AM +0200, Christian Engelmayer wrote:
>> Function read_dump() memory maps the input via grab_file(), but fails to call
>> the corresponding unmap function. Add the missing call to release_file().
>> Detected by Coverity: CID 1192419
> 
> It doesn't matter at all. All memory is freed on exit() in this program.

The leak can disturb in valgrind output.

Michal

