Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030429AbaLLOoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 09:44:23 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:32843 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968081AbaLLOoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 09:44:19 -0500
MIME-Version: 1.0
Date: Fri, 12 Dec 2014 14:44:18 +0000
Message-ID: <CALyZvKzp6Soni8kcBzX=NcvXWhkwPF4vXNmvBXhet9Mc76+NJw@mail.gmail.com>
Subject: how to build 2.6.x based kernel with perf ?
From: Jason Vas Dias <jason.vas.dias@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day -
I am trying to build the latest RHEL kernel from the source RPM,
but this fails because the "perf" component cannot build .
The build gets as far as building the modules and debug flavour
of the kernel, but fails for the 'perf' target with :


+ make -j4 -C tools/perf -s V=1 prefix=/usr all
    CHK -fstack-protector-all
    CHK -Wstack-protector
    CHK -Wvolatile-register-var
    CHK -D_FORTIFY_SOURCE=2
    CHK bionic
<stdin>:1:31: error: android/api-level.h: No such file or directory
<stdin>: In function 'main':
<stdin>:5: error: '__ANDROID_API__' undeclared (first use in this function)
<stdin>:5: error: (Each undeclared identifier is reported only once
<stdin>:5: error: for each function it appears in.)
    CHK libelf
    CHK libdw
    CHK -DLIBELF_MMAP
    CHK -DHAVE_ELF_GETPHDRNUM
    CHK -DLIBELF_MMAP
    CHK libunwind
    CHK libaudit
cc1: warnings being treated as errors
<stdin>: In function 'main':
<stdin>:5: error: implicit declaration of function 'printf'
<stdin>:5: error: incompatible implicit declaration of built-in
function 'printf'
config/Makefile:240: No libaudit.h found, disables 'trace' tool,
please install audit-libs-devel or libaudit-dev
    CHK libslang
    CHK gtk2
    CHK -DHAVE_GTK_INFO_BAR
    CHK perl
    CHK python
    CHK python version
    CHK libbfd
    CHK -DHAVE_STRLCPY
/tmp/ccOCUfYU.o: In function `main':
:(.text+0x14): undefined reference to `strlcpy'
collect2: ld returned 1 exit status
    CHK -DHAVE_ON_EXIT
    CHK -DBACKTRACE_SUPPORT
    CHK libnuma
<stdin>:1:18: error: numa.h: No such file or directory
<stdin>:2:20: error: numaif.h: No such file or directory
cc1: warnings being treated as errors
<stdin>: In function 'main':
<stdin>:6: error: implicit declaration of function 'numa_available'
<stdin>:6: error: nested extern declaration of 'numa_available'
config/Makefile:422: No numa.h found, disables 'perf bench numa mem'
benchmark, please install numa-libs-devel or libnuma-dev
    * new build flags or prefix
PERF_VERSION = 2.6.32-504.1.3.el6.x86_64.debug
    * new build flags or cross compiler
cc1: warnings being treated as errors
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:113:
error: no previous prototype for 'breakpoint'
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:119:
error: no previous prototype for 'alloc_arg'
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'find_cmdline':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:183:
error: return discards qualifiers from pointer target type
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:186:
error: return discards qualifiers from pointer target type
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:195:
error: return discards qualifiers from pointer target type
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'type_size':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:1243:
error: missing initializer
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:1243:
error: (near initialization for 'table[9].type')
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'event_read_fields':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:1519:
error: signed and unsigned type in conditional expression
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'arg_num_eval':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:2076:
error: enumeration value 'PRINT_HEX' not handled in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:2076:
error: enumeration value 'PRINT_DYNAMIC_ARRAY' not handled in switc
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:2076:
error: enumeration value 'PRINT_FUNC' not handled in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'arg_eval':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:2235:
error: enumeration value 'PRINT_HEX' not handled in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:2235:
error: enumeration value 'PRINT_DYNAMIC_ARRAY' not handled in switc
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:2235:
error: enumeration value 'PRINT_FUNC' not handled in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'process_func_handler':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:2693:
error: assignment discards qualifiers from pointer target type
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:2695:
error: assignment discards qualifiers from pointer target type
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'eval_num_arg':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3291:
error: enumeration value 'PRINT_NULL' not handled in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3291:
error: enumeration value 'PRINT_ATOM' not handled in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3291:
error: enumeration value 'PRINT_FLAGS' not handled in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3291:
error: enumeration value 'PRINT_SYMBOL' not handled in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3291:
error: enumeration value 'PRINT_HEX' not handled in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3291:
error: enumeration value 'PRINT_TYPE' not handled in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3291:
error: enumeration value 'PRINT_STRING' not handled in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3291:
error: enumeration value 'PRINT_BSTRING' not handled in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3291:
error: enumeration value 'PRINT_OP' not handled in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3291:
error: enumeration value 'PRINT_FUNC' not handled in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3238:
error: enumeration value 'PRINT_DYNAMIC_ARRAY' not handled in switc
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'print_str_arg':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3496:
error: enumeration value 'PRINT_DYNAMIC_ARRAY' not handled in switc
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'process_defined_func':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3660:
error: enumeration value 'PEVENT_FUNC_ARG_VOID' not handled in swit h
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3660:
error: enumeration value 'PEVENT_FUNC_ARG_MAX_TYPES' not handled in
switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'print_mac_arg':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3927:
error: initialization discards qualifiers from pointer target type
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3941:
error: assignment discards qualifiers from pointer target type
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'print_event_fields':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:3969:
error: unused parameter 'size'
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'pevent_print_event':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:4446:
error: initialization discards qualifiers from pointer target type
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'print_args':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:4671:
error: enumeration value 'PRINT_DYNAMIC_ARRAY' not handled in switc
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:4671:
error: enumeration value 'PRINT_FUNC' not handled in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
At top level:
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:4936:
error: no previous prototype for '__pevent_parse_format'
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'pevent_strerror':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:5131:
error: enumeration value 'PEVENT_ERRNO__SUCCESS' not handled in swi ch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:5131:
error: enumeration value '__PEVENT_ERRNO__START' not handled in swi ch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:5131:
error: enumeration value 'PEVENT_ERRNO__INVALID_ARG_TYPE' not handl d
in switch
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:5131:
error: enumeration value '__PEVENT_ERRNO__END' not handled in switc
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:5108:
error: unused parameter 'pevent'
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
At top level:
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:5149:
error: no previous prototype for 'get_field_val'
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'pevent_register_print_function':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:5400:
error: comparison of unsigned expression < 0 is always false
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:
In function 'pevent_free':
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:5597:
error: comparison between signed and unsigned integer expressions
/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/event-parse.c:5619:
error: comparison between signed and unsigned integer expressions
make[2]: *** [event-parse.o] Error 1
make[1]: *** [/home/jvasdias/rpmbuild/BUILD/kernel-2.6.32-504.1.3.el6/linux-2.6.32-504.1.3.el6.x86_64/tools/lib/traceevent/libtraceevent.a]
Error 2
make[1]: *** Waiting for unfinished jobs....
error: Bad exit status from /var/tmp/rpm-tmp.BbYDKz (%build)


Could anyone please advise how to build the perf target ?
What dependencies are missing ?

Thanks & Regards,
Jason
