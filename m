Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935739Ab3DHMXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:23:10 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:59940 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935127Ab3DHMXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:23:08 -0400
X-IronPort-AV: E=Sophos;i="4.87,431,1363129200"; 
   d="scan'208";a="12279883"
Date: Mon, 8 Apr 2013 14:23:06 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: Hardware locality (hwloc) v1.7 released
Message-ID: <20130408122306.GC6563@type.bordeaux.inria.fr>
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
of v1.7:

   http://www.open-mpi.org/projects/hwloc/

v1.7 is a major new release series.  The v1.6 series focused on the core
rework to ease the addition of new discovery components. As expected,
v1.7 now adds many new discovery components for GPUs, Xeon Phi, BlueGene/Q,
and NetBSD.

There are also a couple changes in the API and in command-line tools,
many documentation improvements, the ability to build external plugins,
and more.

* New operating system backends
  + Add BlueGene/Q compute node kernel (CNK) support. See the FAQ in the
    documentation for details. Thanks to Jeff Hammond, Christopher Samuel
    and Erik Schnetter for their help.
  + Add NetBSD support, thanks to Aleksej Saushev.
* New I/O device discovery
  + Add co-processor OS devices such as "mic0" for Intel Xeon Phi (MIC)
    on Linux. Thanks to Jerome Vienne for helping.
  + Add co-processor OS devices such as "cuda0" for NVIDIA CUDA-capable GPUs.
  + Add co-processor OS devices such as "opencl0d0" for OpenCL GPU devices
    on the AMD OpenCL implementation.
  + Add GPU OS devices such as ":0.0" for NVIDIA X11 displays.
  + Add GPU OS devices such as "nvml0" for NVIDIA GPUs.
    Thanks to Marwan Abdellah and Stefan Eilemann for helping.
  These new OS devices have some string info attributes such as CoProcType,
  GPUModel, etc. to better identify them.
  See the I/O Devices and Attributes documentation sections for details.
* New components
  + Add the "opencl", "cuda", "nvml" and "gl" components for I/O device
    discovery.
  + "nvml" also improves the discovery of NVIDIA GPU PCIe link speed.
  All of these new components may be built as plugins. They may also be
  disabled entirely by passing --disable-opencl/cuda/nvml/gl to configure.
  See the I/O Devices, Components and Plugins, and FAQ documentation
  sections for details.
* API
  + Add hwloc_topology_get_flags().
  + Add hwloc/plugins.h for building external plugins.
    See the Adding new discovery components and plugins section.
* Interoperability
  + Add hwloc/opencl.h, hwloc/nvml.h, hwloc/gl.h and hwloc/intel-mic.h
    to retrieve the locality of OS devices that correspond to AMD OpenCL
    GPU devices or indexes, to NVML devices or indexes, to NVIDIA X11
    displays, or to Intel Xeon Phi (MIC) device indexes.
  + Add new helpers in hwloc/cuda.h and hwloc/cudart.h to convert
    between CUDA devices or indexes and hwloc OS devices.
  + Add hwloc_ibv_get_device_osdev() and clarify the requirements
    of the OpenFabrics Verbs helpers in hwloc/openfabrics-verbs.h.
* Tools
  + hwloc-info is not only a synonym of lstopo -s anymore, it also
    dumps information about objects given on the command-line.
* Documentation
  + Add a section "Existing components and plugins".
  + Add a list of common OS devices in section "Software devices".
  + Add a new FAQ entry "Why is lstopo slow?" about lstopo slowness
    issues because of GPUs.
  + Clarify the documentation of inline helpers in hwloc/myriexpress.h
    and hwloc/openfabrics-verbs.h.
* Misc
  + Improve cache detection on AIX.
  + The HWLOC_COMPONENTS variable now excludes the components whose
    names are prefixed with '-'.
  + lstopo --ignore PU now works when displaying the topology in
    graphical and textual mode (not when exporting to XML).
  + Make sure I/O options always appear in lstopo usage, not only when
    using pciutils/libpci.
  + Remove some unneeded Linux specific includes from some interoperability
    headers.
  + Fix some inconsistencies in hwloc-distrib and hwloc-assembler-remote
    manpages. Thanks to Guy Streeter for the report.
  + Fix a memory leak on AIX when getting memory binding.
  + Fix many small memory leaks on Linux. 
  + The `libpci' component is now called `pci' but the old name is still
    accepted in the HWLOC_COMPONENTS variable for backward compatibility.
