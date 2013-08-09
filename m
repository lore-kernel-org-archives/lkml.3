Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab3HIA7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:59:34 -0400
Received: from server506j.appriver.com ([50.56.144.148]:52629 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758218Ab3HIA7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:59:32 -0400
X-Note-AR-ScanTimeLocal: 8/8/2013 7:59:31 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: Too many policies to list
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-Virus-Scan: V-
X-Note-SnifferID: 0
X-Note: TCH-CT/SI:0-10/SG:2 8/8/2013 7:58:34 PM
X-GBUdb-Analysis: 0, 10.242.229.139, Ugly c=1 p=-0.963102 Source White
X-Signature-Violations: 0-0-0-5444-c
X-Note-419: 15.5998 ms. Fail:0 Chk:1343 of 1343 total
X-Note: SCH-CT/SI:0-1343/SG:1 8/8/2013 7:59:25 PM
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->PRIVATE->UNITED STATES
X-Note-Sending-IP: 10.242.229.139
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G319 G320 G321 G322 G326 G327 G434 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: VALID
X-Note: Headers Injected
Subject: Re: [PATCH 04/22] block: Abstract out bvec iterator
MIME-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
From: Ed Cashin <ecashin@coraid.com>
In-Reply-To: <20130809000943.GC15409@kmo-pixel>
Date: Thu, 8 Aug 2013 20:59:11 -0400
CC: "axboe@kernel.dk" <axboe@kernel.dk>, "neilb@suse.de" <neilb@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <F14F555B-1B1C-4E73-8AF8-DE57D77C610D@coraid.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com> <1375912471-5106-5-git-send-email-kmo@daterainc.com> <2D8F228B-65AE-4046-A910-6B354AF0058E@coraid.com> <20130809000943.GC15409@kmo-pixel>
To: Kent Overstreet <kmo@daterainc.com>
X-Mailer: Apple Mail (2.1085)
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 8, 2013, at 8:09 PM, Kent Overstreet wrote:

> On Wed, Aug 07, 2013 at 10:04:36PM -0400, Ed Cashin wrote:
>> On Aug 7, 2013, at 5:54 PM, Kent Overstreet wrote:
>> 
>>> Immutable biovecs are going to require an explicit iterator. To
>>> implement immutable bvecs, a later patch is going to add a bi_bvec_done
>>> member to this struct; for now, this patch effectively just renames
>>> things.
>> 
>> Hi, Kent Overstreet.  Thanks for Cc'ing me and for the promising work.
>> 
>> Were you able to do sanity tests with aoe this time around?  Last time, basic I/O was not working with the immutable biovec patches applied.
>> 
>> Here is my 28 June email about my experiences with git://evilpiepirate.org/~kent/linux-bcache.git at that time.  It also includes information about creating an easy software-only aoe test environment.
>> 
>>  http://thread.gmane.org/gmane.linux.kernel/1505222/focus=1517924
> 
> Hey, thanks for testing it - sorry, I think I remember seeing that email
> last time and got sidetracked before I got around to setting up some
> tests.

No worries.

> I think I've got it working now, it's running the same stress tests I
> use for bcache. Here's a fixed patch, I broke the aoe changes out into
> their own patch since they were more involved than most of the others:

I had added your git tree as a remote and checked out the for-jens branch.  This patch conflicts with some of the changes in that patch, so I could use a pointer as to which base this new patch applies to.

If it's already in some branch in linux-bcache, I can just use it there, and that's even more convenient.

> (I am seeing a bug where it's getting stuck after running stress tests
> for awhile, but I can reproduce that without the aoe changes too...)

Just so I know what to look for, what does that behavior look like?  I/O stops going and procs get stuck in disk sleep, maybe?

Thanks.

-- 
  Ed Cashin
  ecashin@coraid.com


