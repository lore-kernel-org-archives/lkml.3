Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbaDGSU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:20:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbaDGSU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:20:58 -0400
Date: Mon, 7 Apr 2014 14:20:34 -0400
From: Don Zickus <dzickus@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jmario@redhat.com,
        fowles@inreach.com, bp@alien8.de
Subject: Re: [PATCH 1/4] perf: Allow ability to map cpus to nodes easily
Message-ID: <20140407182034.GF5328@redhat.com>
References: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
 <1395689577-214654-2-git-send-email-dzickus@redhat.com>
 <874n2byncs.fsf@sejong.aot.lge.com>
 <20140406121546.GC1164@krava.brq.redhat.com>
 <87mwfxyags.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwfxyags.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 02:28:35PM +0900, Namhyung Kim wrote:
> On Sun, 6 Apr 2014 14:15:46 +0200, Jiri Olsa wrote:
> > On Thu, Apr 03, 2014 at 02:48:51PM +0900, Namhyung Kim wrote:
> >> More generally, this sysfs access needs to check actual mountpoint using
> >> sysfs__mountpoint() IMHO.
> >> 
> >> Also this API can be generalized like reading int value from a sysfs
> >> file as the filename itself represents the content in most cases.
> >> 
> >> So how about changing this way?  It might reside on somewhere in tools/lib/api/fs/.
> >> 
> >>   max_cpu_num = sysfs__read_int("devices/system/cpu/possible");
> >> 
> >>   max_node_num = sysfs__read_int("devices/system/node/possible");
> >> 
> >> 
> >> Hmm.. looking at the code, perf already has filename__read_{int,str} API
> >> in util/util.c.  Maybe you can just use it instead.
> >
> > I think those just read the file, while Don needs to parse
> > the map to get max cpu number
> 
> Ah, missed that... sorry for noise.

Well, I already implemented using filename__read_str.  It is just added
overhead, but the end result is the same, a string needs to be read from
the file.  I just had to remember to free the memory at the end of the
function.

Cheers,
Don
