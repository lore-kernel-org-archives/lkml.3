Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab3DAUpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:45:16 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58075 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab3DAUpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:45:14 -0400
Message-ID: <5159F1D5.2040601@gmail.com>
Date: Mon, 01 Apr 2013 14:45:09 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/27] perf tools: Build changes and kbuild support
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------000400000801090103090401"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000400000801090103090401
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jiri:

On 4/1/13 1:18 PM, Jiri Olsa wrote:
> hi,
> sending RFC for build changes and kbuild support.

Have you seen this patch set:
https://lkml.org/lkml/2012/8/20/59

It hooks into the conf commands to generate a .config file. 
Coincidentally I updated and expanded the patch series this morning to 
include dependencies and such. Latest Pconfig attached to give you an 
idea. I need to collapse a few patches and send them out tonight.

David

--------------000400000801090103090401
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="Pconfig"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Pconfig"

config ARCH
    string
    option env="ARCH"

config X86
    def_bool y if ARCH = "x86"
    select HAVE_CFI_UNWIND_SUPPORT 

config HAVE_CFI_UNWIND_SUPPORT
    bool

config BIONIC
    bool "Enable support for Bionic (e.g., Android platform)"
    default n
    select LIBC

config NEWT
    bool "Enable newt-based TUI"

config GTK2
    bool "Enable GTK-based UI"

config LIBC
    bool "Development support for libc is available - glibc or bionic"

config LIBELF
    bool "Enable support for libelf"
    depends on !BIONIC && LIBC

config LIBUNWIND
    bool "Enable support for libunwind"
    depends on HAVE_CFI_UNWIND_SUPPORT
    depends on LIBELF

config DEMANGLE
    bool "Enable support for demangle"
    depends on LIBELF

config DWARF
    bool "Enable support for dwarf"
    depends on LIBELF

config LIBAUDIT
    bool "Enable support for libaudit"
    help
        Used for perf trace tool.

config LIBNUMA
    bool "Enable support for libnuma"
    help
        Used for 'perf bench numa mem' benchmark

config BACKTRACE
    bool "Enable support for stack backtrace debugging"

config LIBPERL
    bool "Enable support for perl scripting engine"

config LIBPYTHON
    bool "Enable support for python scripting engine"

--------------000400000801090103090401--
