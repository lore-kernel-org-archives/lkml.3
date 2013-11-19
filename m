Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3KSNPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:15:09 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:19905
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021Ab3KSNPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:15:08 -0500
X-IronPort-AV: E=Sophos;i="4.93,729,1378850400"; 
   d="scan'208";a="36461949"
Date: Tue, 19 Nov 2013 14:15:06 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: Hardware locality (hwloc) v1.8 released
Message-ID: <20131119131506.GB24580@type.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hardware Locality (hwloc) team is pleased to announce the release
of v1.8:

   http://www.open-mpi.org/projects/hwloc/

v1.8 is a major new release series.
It adds PCI discovery on Linux without dependencies on external libs,
a new API to manipulate differences between very similar topologies,
multiple improvements to command-line tools, and more.

* New components
  + Add the "linuxpci" component that always works on Linux even when
    libpciaccess and libpci aren't available (and even with a modified
    file-system root). By default the old "pci" component runs first
    because "linuxpci" lacks device names (obj->name is always NULL).
* API
  + Add the topology difference API in hwloc/diff.h for manipulating
    many similar topologies.
  + Add hwloc_topology_dup() for duplicating an entire topology.
  + hwloc.h and hwloc/helper.h have been reorganized to clarify the
    documentation sections. The actual inline code has moved out of hwloc.h
    into the new hwloc/inlines.h.
  + Deprecated functions are now in hwloc/deprecated.h, and not in the
    official documentation anymore.
* Tools
  + Add hwloc-diff and hwloc-patch tools together with the new diff API.
  + Add hwloc-compress-dir to (de)compress an entire directory of XML files
    using hwloc-diff and hwloc-patch.
  + Object colors in the graphical output of lstopo may be changed by adding
    a "lstopoStyle" info attribute. See CUSTOM COLORS in the lstopo(1) manpage
    for details. Thanks to Jirka Hladky for discussing the idea.
  + hwloc-gather-topology may now gather I/O-related files on Linux when
    --io is given. Only the linuxpci component supports discovering I/O
    objects from these extended tarballs.
  + hwloc-annotate now supports --ri to remove/replace info attributes with
    a given name.
  + hwloc-info supports "root" and "all" special locations for dumping
    information about the root object.
  + lstopo now supports --append-legend to append custom lines of text
    to the legend in the graphical output. Thanks to Jirka Hladky for
    discussing the idea.
  + hwloc-calc and friends have a more robust parsing of locations given
    on the command-line and they report useful error messages about it.
  + Add --whole-system to hwloc-bind, hwloc-calc, hwloc-distances and
    hwloc-distrib, and add --restrict to hwloc-bind for uniformity among
    tools.
* Misc
  + Calling hwloc_topology_load() or hwloc_topology_set_*() on an already
    loaded topology now returns an error (deprecated since release 1.6.1).
  + Fix the initialisation of cpusets and nodesets in Group objects added
    when inserting PCI hostbridges.
  + Never merge Group objects that were added explicitly by the user with
    hwloc_custom_insert_group_object_by_parent().
  + Add a sanity check during dynamic plugin loading to prevent some
    crashes when hwloc is dynamically loaded by another plugin mechanisms.
  + Add --with-hwloc-plugins-path to specify the install/load directories
    of plugins.
  + Add the MICSerialNumber info attribute to the root object when running
    hwloc inside a Xeon Phi to match the same attribute in the MIC OS device
    when running in the host.


Changes since v1.8rc1 only consists in minor documentation updates,
test improvements and warning fixes.
