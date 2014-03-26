Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbaCZLv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:51:28 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:7800 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780AbaCZLvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:51:25 -0400
X-IronPort-AV: E=Sophos;i="4.97,735,1389740400"; 
   d="scan'208";a="54181944"
Date: Wed, 26 Mar 2014 12:51:23 +0100
From: Samuel Thibault <samuel.thibault@labri.fr>
To: runtime@labri.fr, linux-kernel@vger.kernel.org, users@lists.grid5000.fr,
        plafrim-users@inria.fr
Subject: Hardware locality (hwloc) v1.9 released
Message-ID: <20140326115123.GN5912@type.bordeaux.inria.fr>
Mail-Followup-To: runtime@labri.fr, linux-kernel@vger.kernel.org,
	users@lists.grid5000.fr, plafrim-users@inria.fr
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hardware Locality (hwloc) team is pleased to announce the release
of v1.9:

   http://www.open-mpi.org/projects/hwloc/

v1.9 is a major new release series.
It adds a couple enhanced API functions, many object attributes for
better representing CPU and I/O device characteristics, and more.

* API
  + Add hwloc_obj_type_sscanf() to extend hwloc_obj_type_of_string() with
    type-specific attributes such as Cache/Group depth and Cache type.
    hwloc_obj_type_of_string() is moved to hwloc/deprecated.h.
  + Add hwloc_linux_get_tid_last_cpu_location() for retrieving the
    last CPU where a Linux thread given by TID ran.
  + Add hwloc_distrib() to extend the old hwloc_distribute[v]() functions.
    hwloc_distribute[v]() is moved to hwloc/deprecated.h.
  + Don't mix total and local memory when displaying verbose object attributes
    with hwloc_obj_attr_snprintf() or in lstopo.
* Backends
  + Add CPUVendor, CPUModelNumber and CPUFamilyNumber info attributes for
    x86, ia64 and Xeon Phi sockets on Linux, to extend the x86-specific
    support added in v1.8.1. Requested by Ralph Castain.
  + Add many CPU- and Platform-related info attributes on ARM and POWER
    platforms, in the Machine and Socket objects.
  + Add CUDA info attributes describing the number of multiprocessors and
    cores and the size of the global, shared and L2 cache memories in CUDA
    OS devices.
  + Add OpenCL info attributes describing the number of compute units and
    the global memory size in OpenCL OS devices.
  + The synthetic backend now accepts extended types such as L2Cache, L1i or
    Group3. lstopo also exports synthetic strings using these extended types.
* Tools
  + lstopo
    - Do not overwrite output files by default anymore.
      Pass -f or --force to enforce it.
    - Display OpenCL, CUDA and Xeon Phi numbers of cores and memory sizes
      in the graphical output.
    - Fix export to stdout when specifying a Cairo-based output type
      with --of.
  + hwloc-ps
    - Add -e or --get-last-cpu-location to report where processes/threads
      run instead of where they are bound.
    - Report locations as likely-more-useful objects such as Cores or Sockets
      instead of Caches when possible.
  + hwloc-bind
    - Fix failure on Windows when not using --pid.
    - Add -e as a synonym to --get-last-cpu-location.
  + hwloc-distrib
    - Add --reverse to distribute using last objects first and singlify
      into last bits first. Thanks to Jirka Hladky for the suggestion.
  + hwloc-info
    - Report unified caches when looking for data or instruction cache
      ancestor objects.
* Misc
  + Add experimental Visual Studio support under contrib/windows.
    Thanks to Eloi Gaudry for his help and for providing the first draft.
  + Fix some overzealous assertions and warnings about the ordering of
    objects on a level with respect to cpusets. The ordering is only
    guaranteed for complete cpusets (based on the first bit in sets).
  + Fix some memory leaks when importing xml diffs and when exporting a
    "too complex" entry.

Changes since v1.9rc1 only consists in minor documentation updates.
