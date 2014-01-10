Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaAJKOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:14:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbaAJKOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:14:39 -0500
Date: Fri, 10 Jan 2014 10:14:34 +0000
From: Mel Gorman <mgorman@suse.de>
To: Len Brown <lenb@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, athorlton@sgi.com,
        Rik van Riel <riel@redhat.com>, chegu_vinod@hp.com,
        Len Brown <len.brown@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Idle power fix regresses ebizzy performance (was 3.12-stable
 backport of NUMA balancing patches)
Message-ID: <20140110101433.GW27046@suse.de>
References: <1389103248-17617-1-git-send-email-mgorman@suse.de>
 <20140107141715.GA32491@kroah.com>
 <20140107185440.GA7844@kroah.com>
 <20140107203012.GA27046@suse.de>
 <20140108104340.GC27046@suse.de>
 <20140108134858.GF27046@suse.de>
 <CAJvTdKmR90tsOWgo-2t9neNFTE15SOYtPN7zgjGKDvafWfk0TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJvTdKmR90tsOWgo-2t9neNFTE15SOYtPN7zgjGKDvafWfk0TA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 03:07:00PM -0500, Len Brown wrote:
> Hi Mel,
> Thanks for the bisect.
> What is the cpuid of the machine that sees the regression?
> 

cpuid information for CPU 0. Machine is 4 socket, 48 threads in total.

CPU 0:
   vendor_id = "GenuineIntel"
   version information (1/eax):
      processor type  = primary processor (0)
      family          = Intel Pentium Pro/II/III/Celeron/Core/Core 2/Atom, AMD Athlon/Duron, Cyrix M2, VIA C3 (6)
      model           = 0xf (15)
      stepping id     = 0x2 (2)
      extended family = 0x0 (0)
      extended model  = 0x2 (2)
      (simple synth)  = Intel Xeon E7-8800 / Xeon E7-4800 / Xeon E7-2800 (Westmere-EX A2), 32nm
   miscellaneous (1/ebx):
      process local APIC physical ID = 0x0 (0)
      cpu count                      = 0x40 (64)
      CLFLUSH line size              = 0x8 (8)
      brand index                    = 0x0 (0)
   brand id = 0x00 (0): unknown
   feature information (1/edx):
      x87 FPU on chip                        = true
      virtual-8086 mode enhancement          = true
      debugging extensions                   = true
      page size extensions                   = true
      time stamp counter                     = true
      RDMSR and WRMSR support                = true
      physical address extensions            = true
      machine check exception                = true
      CMPXCHG8B inst.                        = true
      APIC on chip                           = true
      SYSENTER and SYSEXIT                   = true
      memory type range registers            = true
      PTE global bit                         = true
      machine check architecture             = true
      conditional move/compare instruction   = true
      page attribute table                   = true
      page size extension                    = true
      processor serial number                = false
      CLFLUSH instruction                    = true
      debug store                            = true
      thermal monitor and clock ctrl         = true
      MMX Technology                         = true
      FXSAVE/FXRSTOR                         = true
      SSE extensions                         = true
      SSE2 extensions                        = true
      self snoop                             = true
      hyper-threading / multi-core supported = true
      therm. monitor                         = true
      IA64                                   = false
      pending break event                    = true
   feature information (1/ecx):
      PNI/SSE3: Prescott New Instructions     = true
      PCLMULDQ instruction                    = true
      64-bit debug store                      = true
      MONITOR/MWAIT                           = true
      CPL-qualified debug store               = true
      VMX: virtual machine extensions         = true
      SMX: safer mode extensions              = true
      Enhanced Intel SpeedStep Technology     = true
      thermal monitor 2                       = true
      SSSE3 extensions                        = true
      context ID: adaptive or shared L1 data  = false
      FMA instruction                         = false
      CMPXCHG16B instruction                  = true
      xTPR disable                            = true
      perfmon and debug                       = true
      process context identifiers             = true
      direct cache access                     = true
      SSE4.1 extensions                       = true
      SSE4.2 extensions                       = true
      extended xAPIC support                  = true
      MOVBE instruction                       = false
      POPCNT instruction                      = true
      time stamp counter deadline             = false
      AES instruction                         = true
      XSAVE/XSTOR states                      = false
      OS-enabled XSAVE/XSTOR                  = false
      AVX: advanced vector extensions         = false
      F16C half-precision convert instruction = false
      RDRAND instruction                      = false
      hypervisor guest status                 = false
   cache and TLB information (2):
      0x5a: data TLB: 2M/4M pages, 4-way, 32 entries
      0x03: data TLB: 4K pages, 4-way, 64 entries
      0x55: instruction TLB: 2M/4M pages, fully, 7 entries
      0xeb: L3 cache: 18M, 24-way, 64 byte lines
      0xb2: instruction TLB: 4K, 4-way, 64 entries
      0xf0: 64 byte prefetching
      0x2c: L1 data cache: 32K, 8-way, 64 byte lines
      0x21: L2 cache: 256K MLC, 8-way, 64 byte lines
      0xca: L2 TLB: 4K, 4-way, 512 entries
      0x09: L1 instruction cache: 32K, 4-way, 64-byte lines
   processor serial number: 0002-06F2-0000-0000-0000-0000
   deterministic cache parameters (4):
      --- cache 0 ---
      cache type                           = data cache (1)
      cache level                          = 0x1 (1)
      self-initializing cache level        = true
      fully associative cache              = false
      extra threads sharing this cache     = 0x1 (1)
      extra processor cores on this die    = 0x1f (31)
      system coherency line size           = 0x3f (63)
      physical line partitions             = 0x0 (0)
      ways of associativity                = 0x7 (7)
      WBINVD/INVD behavior on lower caches = false
      inclusive to lower caches            = false
      complex cache indexing               = false
      number of sets - 1 (s)               = 63
      --- cache 1 ---
      cache type                           = instruction cache (2)
      cache level                          = 0x1 (1)
      self-initializing cache level        = true
      fully associative cache              = false
      extra threads sharing this cache     = 0x1 (1)
      extra processor cores on this die    = 0x1f (31)
      system coherency line size           = 0x3f (63)
      physical line partitions             = 0x0 (0)
      ways of associativity                = 0x3 (3)
      WBINVD/INVD behavior on lower caches = false
      inclusive to lower caches            = false
      complex cache indexing               = false
      number of sets - 1 (s)               = 127
      --- cache 2 ---
      cache type                           = unified cache (3)
      cache level                          = 0x2 (2)
      self-initializing cache level        = true
      fully associative cache              = false
      extra threads sharing this cache     = 0x1 (1)
      extra processor cores on this die    = 0x1f (31)
      system coherency line size           = 0x3f (63)
      physical line partitions             = 0x0 (0)
      ways of associativity                = 0x7 (7)
      WBINVD/INVD behavior on lower caches = false
      inclusive to lower caches            = false
      complex cache indexing               = false
      number of sets - 1 (s)               = 511
      --- cache 3 ---
      cache type                           = unified cache (3)
      cache level                          = 0x3 (3)
      self-initializing cache level        = true
      fully associative cache              = false
      extra threads sharing this cache     = 0x3f (63)
      extra processor cores on this die    = 0x1f (31)
      system coherency line size           = 0x3f (63)
      physical line partitions             = 0x0 (0)
      ways of associativity                = 0x17 (23)
      WBINVD/INVD behavior on lower caches = false
      inclusive to lower caches            = true
      complex cache indexing               = true
      number of sets - 1 (s)               = 12287
   MONITOR/MWAIT (5):
      smallest monitor-line size (bytes)       = 0x40 (64)
      largest monitor-line size (bytes)        = 0x40 (64)
      enum of Monitor-MWAIT exts supported     = true
      supports intrs as break-event for MWAIT  = true
      number of C0 sub C-states using MWAIT    = 0x0 (0)
      number of C1 sub C-states using MWAIT    = 0x2 (2)
      number of C2 sub C-states using MWAIT    = 0x1 (1)
      number of C3/C6 sub C-states using MWAIT = 0x1 (1)
      number of C4/C7 sub C-states using MWAIT = 0x0 (0)
   Thermal and Power Management Features (6):
      digital thermometer                     = true
      Intel Turbo Boost Technology            = false
      ARAT always running APIC timer          = true
      PLN power limit notification            = false
      ECMD extended clock modulation duty     = false
      PTM package thermal management          = false
      digital thermometer thresholds          = 0x1 (1)
      ACNT/MCNT supported performance measure = true
      ACNT2 available                         = false
      performance-energy bias capability      = false
   extended feature flags (7):
      FSGSBASE instructions                   = false
      BMI instruction                         = false
      SMEP support                            = false
      enhanced REP MOVSB/STOSB                = false
      INVPCID instruction                     = false
   Direct Cache Access Parameters (9):
      PLATFORM_DCA_CAP MSR bits = 0
   Architecture Performance Monitoring Features (0xa/eax):
      version ID                               = 0x3 (3)
      number of counters per logical processor = 0x4 (4)
      bit width of counter                     = 0x30 (48)
      length of EBX bit vector                 = 0x7 (7)
   Architecture Performance Monitoring Features (0xa/ebx):
      core cycle event not available           = false
      instruction retired event not available  = false
      reference cycles event not available     = true
      last-level cache ref event not available = false
      last-level cache miss event not avail    = false
      branch inst retired event not available  = false
      branch mispred retired event not avail   = false
   Architecture Performance Monitoring Features (0xa/edx):
      number of fixed counters    = 0x3 (3)
      bit width of fixed counters = 0x30 (48)
   x2APIC features / processor topology (0xb):
      --- level 0 (thread) ---
      bits to shift APIC ID to get next = 0x1 (1)
      logical processors at this level  = 0x2 (2)
      level number                      = 0x0 (0)
      level type                        = thread (1)
      extended APIC ID                  = 0
      --- level 1 (core) ---
      bits to shift APIC ID to get next = 0x6 (6)
      logical processors at this level  = 0xc (12)
      level number                      = 0x1 (1)
      level type                        = core (2)
      extended APIC ID                  = 0
   extended feature flags (0x80000001/edx):
      SYSCALL and SYSRET instructions        = true
      execution disable                      = true
      1-GB large page support                = true
      RDTSCP                                 = true
      64-bit extensions technology available = true
   Intel feature flags (0x80000001/ecx):
      LAHF/SAHF supported in 64-bit mode = true
   brand = "       Intel(R) Xeon(R) CPU E7- 4807  @ 1.87GHz"
   L1 TLB/cache information: 2M/4M pages & L1 TLB (0x80000005/eax):
      instruction # entries     = 0x0 (0)
      instruction associativity = 0x0 (0)
      data # entries            = 0x0 (0)
      data associativity        = 0x0 (0)
   L1 TLB/cache information: 4K pages & L1 TLB (0x80000005/ebx):
      instruction # entries     = 0x0 (0)
      instruction associativity = 0x0 (0)
      data # entries            = 0x0 (0)
      data associativity        = 0x0 (0)
   L1 data cache information (0x80000005/ecx):
      line size (bytes) = 0x0 (0)
      lines per tag     = 0x0 (0)
      associativity     = 0x0 (0)
      size (Kb)         = 0x0 (0)
   L1 instruction cache information (0x80000005/edx):
      line size (bytes) = 0x0 (0)
      lines per tag     = 0x0 (0)
      associativity     = 0x0 (0)
      size (Kb)         = 0x0 (0)
   L2 TLB/cache information: 2M/4M pages & L2 TLB (0x80000006/eax):
      instruction # entries     = 0x0 (0)
      instruction associativity = L2 off (0)
      data # entries            = 0x0 (0)
      data associativity        = L2 off (0)
   L2 TLB/cache information: 4K pages & L2 TLB (0x80000006/ebx):
      instruction # entries     = 0x0 (0)
      instruction associativity = L2 off (0)
      data # entries            = 0x0 (0)
      data associativity        = L2 off (0)
   L2 unified cache information (0x80000006/ecx):
      line size (bytes) = 0x40 (64)
      lines per tag     = 0x0 (0)
      associativity     = 8-way (6)
      size (Kb)         = 0x100 (256)
   L3 cache information (0x80000006/edx):
      line size (bytes)     = 0x0 (0)
      lines per tag         = 0x0 (0)
      associativity         = L2 off (0)
      size (in 512Kb units) = 0x0 (0)
   Advanced Power Management Features (0x80000007/edx):
      temperature sensing diode      = false
      frequency ID (FID) control     = false
      voltage ID (VID) control       = false
      thermal trip (TTP)             = false
      thermal monitor (TM)           = false
      software thermal control (STC) = false
      100 MHz multiplier control     = false
      hardware P-State control       = false
      TscInvariant                   = true
   Physical Address and Linear Address Size (0x80000008/eax):
      maximum physical address bits         = 0x2c (44)
      maximum linear (virtual) address bits = 0x30 (48)
      maximum guest physical address bits   = 0x0 (0)
   Logical CPU cores (0x80000008/ecx):
      number of CPU cores - 1 = 0x0 (0)
      ApicIdCoreIdSize        = 0x0 (0)
   (multi-processing synth): multi-core (c=6), hyper-threaded (t=2)
   (multi-processing method): Intel leaf 0xb
   (APIC widths synth): CORE_width=6 SMT_width=1
   (APIC synth): PKG_ID=0 CORE_ID=0 SMT_ID=0
   (synth) = Intel Xeon E7-8800 / Xeon E7-4800 / Xeon E7-2800 (Westmere-EX A2), 32nm

-- 
Mel Gorman
SUSE Labs
