Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965893AbaH1LUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:20:04 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:44238 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965872AbaH1LUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:20:01 -0400
Message-ID: <53FF105B.1000103@hitachi.com>
Date: Thu, 28 Aug 2014 20:19:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hemant@linux.vnet.ibm.com>, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v4 0/3] perf/sdt : Support for SDT markers
References: <20140827213745.13454.46266.stgit@hemant-fedora>
In-Reply-To: <20140827213745.13454.46266.stgit@hemant-fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/28 6:43), Hemant Kumar wrote:
> The v3 patchset had some spacing errors because of my editor messing up during
> sending the patches. Resending the patchset again.
> This patchset helps in listing dtrace style markers(SDT) present in user space
> applications through perf.
> Notes/markers are placed at important places by the
> developers. They have a negligible overhead when not enabled.
> We can enable them and probe at these places and find some important information
> like the arguments' values, etc.
> 
> We have lots of applications which use SDT markers today, like:
> Postgresql, MySql, Mozilla, Perl, Python, Java, Ruby, libvirt, QEMU, glib
> 
> To add SDT markers into user applications:
> We need to have this header sys/sdt.h present.
> sys/sdt.h used is version 3.
> If not present, install systemtap-sdt-devel package (for fedora-18).
> 
> Please refer to the Documentation patch (3rd patch in this series) to see how the
> SDT markers are added into a program.
> 
> With this patchset,
> - Use perf to list the markers in the app:
> # perf list sdt ./user_app
> 
> ./user_app :
> %user_app:foo_start
> %user_app:fun_start
> 
> This link shows an example of marker probing with Systemtap:
> https://sourceware.org/systemtap/wiki/AddingUserSpaceProbingToApps
> 
> Also, this link provides important info regarding SDT notes:
> http://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation
> 
> This patchset has undergone a lot of changes since it was first introduced.
> Hence, the patchset has now been subdivided for more simplicity and ease of
> review (thanks to the suggestion from Namhyung Kim). This contains the first 2
> of the 4 patches as suggested here:
> https://lkml.org/lkml/2014/7/20/284

BTW, does this series only contain list command support?

> - Markers in binaries :
> These SDT markers are present in the ELF in the section named
> ".note.stapsdt".
> Here, the name of the marker, its provider, type, location, base
> address, semaphore address.
> We can retrieve these values using the members name_off and desc_off in
> Nhdr structure. If these are not enabled, they are present in the ELF as nop.
> 
> Changes since last series :
> - Subdivided the previous patchset into 4 patches to make it easier to review
>   as suggested by Namhyung Kim. (This set includes first two of the four patches)
> - Made the required changes and some optimizations suggested by Masami, Namhyung
>   and Andi.
> 
> TODO:
> - Listing SDT events present in most of the binaries present in a system.
> - Maintaining a cache of the SDT events for faster lookup.
> - Add support to probe these SDT markers and integrate with a previous patch
>   (support to perf to probe SDT markers) posted in lkml.
>   https://lkml.org/lkml/2013/10/23/10

OK, I think we can postpone sdt-cache command, but this should go with
probe-side improvements, because if perf-list shows sdt markers, users
will be misled that the perf already supports sdt events.
I'm OK if we hold this on a non-released branch on acme's tree. But it
shouldn't be pushed to upstream without probe-side improvements.

Arnaldo, would you think that works on your tree?

Thank you,



-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


