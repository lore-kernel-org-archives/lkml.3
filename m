Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaHUWeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 18:34:14 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:59884 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458AbaHUWeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 18:34:11 -0400
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi
Subject: [PATCH][RFC] Compile test script for exported header files
Date: Fri, 22 Aug 2014 01:34:09 +0300
Message-Id: <1408660449-4011-1-git-send-email-mikko.rapeli@iki.fi>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:1bc8:1004::1
X-SA-Exim-Mail-From: mcfrisk@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users of kernel header files would be happier if they did not contain
kernel specific parts and would contain #include statements for all
other header files that they depend on, and in general would compile.

For each header file exported to userspace, the script creates
a simple .c file which just includes the header file. Then it
tries to compile it and reports results.

Execute the script like this:

$ make headers_install
$ cd usr/include
$ ../../scripts/headers_compile_test.sh

Example statistics from 3.15.9 kernel:

152 files failed the compile test.
576 files passed the compile test.

Example error count from 3.15.9:

$ ../../scripts/headers_compile_test.sh 2>&1 | \
grep error: | sed -e 's/.*error://g' | sort | uniq -c | sort -rn

    189  unknown type name ‘uint32_t’
    103  unknown type name ‘size_t’
     97  unknown type name ‘uint64_t’
     43  unknown type name ‘__kernel_ulong_t’
     36  unknown type name ‘uint8_t’
     22  field ‘addr’ has incomplete type
     18  field ‘tstamp’ has incomplete type
     16  unknown type name ‘__kernel_time_t’
     16  field ‘in’ has incomplete type
     16  field ‘in6’ has incomplete type
     14  unknown type name ‘__be16’
     13  ‘IFNAMSIZ’ undeclared here (not in a function)
     10  sys/time.h: No such file or directory
      9  unknown type name ‘uint16_t’
      9  field ‘ifru_netmask’ has incomplete type
      9  field ‘ifru_hwaddr’ has incomplete type
      9  field ‘ifru_dstaddr’ has incomplete type
      9  field ‘ifru_broadaddr’ has incomplete type
      9  field ‘ifru_addr’ has incomplete type
      8  unknown type name ‘__kernel_pid_t’
      7  unknown type name ‘u_short’
      7  unknown type name ‘pid_t’
      6  invalid application of ‘sizeof’ to incomplete type ‘struct timespec’
      6  field ‘audio_tstamp’ has incomplete type
      5  unknown type name ‘__kernel_long_t’
      5  string.h: No such file or directory
      5  requested alignment is not an integer constant
      5  limits.h: No such file or directory
      5  array type has incomplete element type
      4  unknown type name ‘__kernel_uid32_t’
      4  unknown type name ‘__kernel_gid32_t’
      4  field ‘src’ has incomplete type
      4  ‘ETH_ALEN’ undeclared here (not in a function)
      3  unknown type name ‘caddr_t’
      3  stdint.h: No such file or directory
      3  ‘IPSET_ERR_TYPE_SPECIFIC’ undeclared here (not in a function)
      3  field ‘trigger_tstamp’ has incomplete type
      3  field ‘src_addr’ has incomplete type
      3  field ‘smsk’ has incomplete type
      3  field ‘sin_addr’ has incomplete type
      3  field ‘laddr’ has incomplete type
      3  field ‘id’ has incomplete type
      3  field ‘bssid’ has incomplete type
      3  expected specifier-qualifier-list before ‘uint64_t’
      2  unknown type name ‘u_long’
      2  unknown type name ‘stack_t’
      2  unknown type name ‘sigset_t’
      2  unknown type name ‘sa_family_t’
      2  unknown type name ‘__kernel_mode_t’
      2  unknown type name ‘__kernel_key_t’
      2  unknown type name ‘int32_t’
      2  unknown type name ‘elf_gregset_t’
      2  unknown type name ‘bool’
      2  unistd.h: No such file or directory
      2  ‘uint64_t’ undeclared here (not in a function)
      2  ‘true’ undeclared (first use in this function)
      2  sys/ioctl.h: No such file or directory
      2  stddef.h: No such file or directory
      2  ‘__kernel_mode_t’ undeclared here (not in a function)
      2  field ‘uc_mcontext’ has incomplete type
      2  field ‘tmsk’ has incomplete type
      2  field ‘tgt’ has incomplete type
      2  field ‘shm_perm’ has incomplete type
      2  field ‘sem_perm’ has incomplete type
      2  field ‘raddr’ has incomplete type
      2  field ‘msg_perm’ has incomplete type
      2  field ‘grp’ has incomplete type
      2  field ‘dst_addr’ has incomplete type
      2  field ‘arp_pa’ has incomplete type
      2  field ‘arp_netmask’ has incomplete type
      2  field ‘arp_ha’ has incomplete type
      2  ‘false’ undeclared (first use in this function)
      2  endian.h: No such file or directory
      1  xen/interface/xen.h: No such file or directory
      1  via_drmclient.h: No such file or directory
      1  unknown type name ‘wait_queue_head_t’
      1  unknown type name ‘u_int8_t’
      1  unknown type name ‘snd_seq_client_type_t’
      1  unknown type name ‘int64_t’
      1  unknown type name ‘int16_t’
      1  unknown type name ‘ino_t’
      1  unknown type name ‘elf_greg_t’
      1  unknown type name ‘elf_fpxregset_t’
      1  unknown type name ‘elf_fpregset_t’
      1  unknown type name ‘__be32’
      1  time.h: No such file or directory
      1  ‘SIOCDEVPRIVATE’ undeclared here (not in a function)
      1  ‘NULL’ undeclared (first use in this function)
      1  netinet/in.h: No such file or directory
      1  ‘MSG_FIN’ undeclared here (not in a function)
      1  ‘MAX_IPOPTLEN’ undeclared here (not in a function)
      1  ‘MAX_ADDR_LEN’ undeclared here (not in a function)
      1  invalid application of ‘sizeof’ to incomplete type ‘struct sockaddr’
      1  ‘IFHWADDRLEN’ undeclared here (not in a function)
      1  field ‘vmask’ has incomplete type
      1  field ‘vifc_rmt_addr’ has incomplete type
      1  field ‘vifc_lcl_addr’ has incomplete type
      1  field ‘vaddr’ has incomplete type
      1  field ‘uc_chain’ has incomplete type
      1  field ‘tgt_ip’ has incomplete type
      1  field ‘tcp’ has incomplete type
      1  field ‘sw_reserved’ has incomplete type
      1  field ‘stamp’ has incomplete type
      1  field ‘sspp_addr’ has incomplete type
      1  field ‘ssp_addr’ has incomplete type
      1  field ‘src_mask’ has incomplete type
      1  field ‘src_ip’ has incomplete type
      1  field ‘spt_address’ has incomplete type
      1  field ‘spp_address’ has incomplete type
      1  field ‘spinfo_address’ has incomplete type
      1  field ‘spc_aaddr’ has incomplete type
      1  field ‘sas_obs_rto_ipaddr’ has incomplete type
      1  field ‘saddr’ has incomplete type
      1  field ‘rtmsg_src’ has incomplete type
      1  field ‘rtmsg_gateway’ has incomplete type
      1  field ‘rtmsg_dst’ has incomplete type
      1  field ‘rt_genmask’ has incomplete type
      1  field ‘rt_gateway’ has incomplete type
      1  field ‘rt_dst’ has incomplete type
      1  field ‘real’ has incomplete type
      1  field ‘prefix’ has incomplete type
      1  field ‘obj_list’ has incomplete type
      1  field ‘mfcc_origin’ has incomplete type
      1  field ‘mfcc_mcastgrp’ has incomplete type
      1  field ‘mf6cc_origin’ has incomplete type
      1  field ‘mf6cc_mcastgrp’ has incomplete type
      1  field ‘mask’ has incomplete type
      1  field ‘ival2’ has incomplete type
      1  field ‘ival1’ has incomplete type
      1  field ‘iph’ has incomplete type
      1  field ‘ip’ has incomplete type
      1  field ‘ip6’ has incomplete type
      1  field ‘im_src’ has incomplete type
      1  field ‘im_dst’ has incomplete type
      1  field ‘im6_src’ has incomplete type
      1  field ‘im6_dst’ has incomplete type
      1  field ‘gw’ has incomplete type
      1  field ‘expected’ has incomplete type
      1  field ‘dst_mask’ has incomplete type
      1  field ‘dmsk’ has incomplete type
      1  field ‘dest_addr’ has incomplete type
      1  field ‘daddr’ has incomplete type
      1  field ‘ap_addr’ has incomplete type
      1  field ‘a6’ has incomplete type
      1  field ‘a4’ has incomplete type
      1  expected specifier-qualifier-list before ‘DECLARE_BITMAP’
      1  expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘snd_seq_client_type_t’
      1  #error "patchkey.h included directly"
      1  drm.h: No such file or directory
      1  ‘DLM_RESNAME_MAXLEN’ undeclared here (not in a function)

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 scripts/headers_compile_test.sh | 48 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100755 scripts/headers_compile_test.sh

diff --git a/scripts/headers_compile_test.sh b/scripts/headers_compile_test.sh
new file mode 100755
index 0000000..57a60f6
--- /dev/null
+++ b/scripts/headers_compile_test.sh
@@ -0,0 +1,48 @@
+#!/bin/bash
+# bash due to arithmetics
+set -e
+set -u
+#set -x
+
+echo Simple compile test for header files meant for userspace.
+
+# sanity test
+if [ ! -d ./linux ]; then
+	echo Sanity check error: ./linux directory not found
+	echo Should be called in usr/include after \'make headers_install\'.
+	echo Returns number of failed files, 0 if none.
+	exit 1
+fi
+
+# For each header file, create a .c which just includes the header file
+# and try to compile it using only current directory for searching other
+# included header files.
+_FAILED=0
+_PASSED=0
+for f in $( find . -name "*\.h" | xargs ); do
+	_FAIL=0
+	CFILE=$( echo "$( dirname $f )/$( basename $f .h ).c" )
+
+	# create .c file
+	echo "#include <$( echo $f | sed -e 's|^.\/||' )>" \
+		> "$(dirname $f)/$(basename $f .h).c"
+
+	# compile test
+	cc -Wall -c -nostdinc -I . "$CFILE" \
+		|| _FAIL=1
+
+	# report errors
+	if [ "$_FAIL" -gt 0 ]; then
+		echo "FAILED: $f"
+		_FAILED=$(( $_FAILED + 1 ))
+	else
+		echo "PASSED: $f"
+		_PASSED=$(( $_PASSED + 1))
+	fi
+done
+
+echo Statistics:
+echo $_FAILED files failed the compile test.
+echo $_PASSED files passed the compile test.
+
+exit $_FAILED
-- 
2.1.0

