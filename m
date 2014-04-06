Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbaDFMQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 08:16:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbaDFMQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 08:16:11 -0400
Date: Sun, 6 Apr 2014 14:15:46 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jmario@redhat.com,
        fowles@inreach.com, bp@alien8.de
Subject: Re: [PATCH 1/4] perf: Allow ability to map cpus to nodes easily
Message-ID: <20140406121546.GC1164@krava.brq.redhat.com>
References: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
 <1395689577-214654-2-git-send-email-dzickus@redhat.com>
 <874n2byncs.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874n2byncs.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 02:48:51PM +0900, Namhyung Kim wrote:
> Hi Don,

SNIP

> 
> More generally, this sysfs access needs to check actual mountpoint using
> sysfs__mountpoint() IMHO.
> 
> Also this API can be generalized like reading int value from a sysfs
> file as the filename itself represents the content in most cases.
> 
> So how about changing this way?  It might reside on somewhere in tools/lib/api/fs/.
> 
>   max_cpu_num = sysfs__read_int("devices/system/cpu/possible");
> 
>   max_node_num = sysfs__read_int("devices/system/node/possible");
> 
> 
> Hmm.. looking at the code, perf already has filename__read_{int,str} API
> in util/util.c.  Maybe you can just use it instead.

I think those just read the file, while Don needs to parse
the map to get max cpu number

jirka
