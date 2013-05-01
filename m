Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab3EAQ4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:56:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:54163 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab3EAQ4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:56:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,590,1363158000"; 
   d="scan'208";a="306295566"
Message-ID: <51814943.7000604@intel.com>
Date: Wed, 01 May 2013 09:56:35 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Samuel.Ortiz@mail.home.local, Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
	To:	Samuel Ortiz
			^-extraneous tokens in address
Subject: mei file2alias compile error
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus's current git isn't compiling for me:

>   HOSTCC  scripts/mod/file2alias.o
> /home/davehans/linux.git/scripts/mod/file2alias.c: In function ‘do_mei_entry’:
> /home/davehans/linux.git/scripts/mod/file2alias.c:1140:1: error: ‘OFF_mei_cl_device_id_name’ undeclared (first use in this function)
> /home/davehans/linux.git/scripts/mod/file2alias.c:1140:1: note: each undeclared identifier is reported only once for each function it appears in
> /home/davehans/linux.git/scripts/mod/file2alias.c: At top level:
> /home/davehans/linux.git/scripts/mod/file2alias.c:1146:1: error: ‘SIZE_mei_cl_device_id’ undeclared here (not in a function)

I confirmed that this commit: e5354107e is the one causing it for me.
My .config is here:

	http://sr71.net/~dave/linux/config-3.9-meibad

Note that I don't even have CONFIG_INTEL_MEI enabled with this config.
