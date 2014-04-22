Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbaDVHjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:39:31 -0400
Received: from ozlabs.org ([103.22.144.67]:39356 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaDVHjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:39:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michal Marek <mmarek@suse.cz>, Andi Kleen <ak@linux.intel.com>,
        Christian Engelmayer <cengelma@gmx.at>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] modpost: Fix ressource leak in read_dump()
In-Reply-To: <53441149.8010902@suse.cz>
References: <20140406003649.1ba3c993@spike> <20140406000512.GS32556@tassilo.jf.intel.com> <53441149.8010902@suse.cz>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 22 Apr 2014 16:56:41 +0930
Message-ID: <87sip5hlji.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.cz> writes:

> On 2014-04-06 02:05, Andi Kleen wrote:
>> On Sun, Apr 06, 2014 at 12:36:49AM +0200, Christian Engelmayer wrote:
>>> Function read_dump() memory maps the input via grab_file(), but fails to call
>>> the corresponding unmap function. Add the missing call to release_file().
>>> Detected by Coverity: CID 1192419
>> 
>> It doesn't matter at all. All memory is freed on exit() in this program.
>
> The leak can disturb in valgrind output.

Yeah.  If release_file() didn't exist at all, I'd agree with Andi.  As
it is, I've queued the patch (with typo in title fixed).

Thanks!
Rusty.
