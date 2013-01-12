Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3ALWdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 17:33:33 -0500
Received: from csamuel.org ([74.50.50.137]:43865 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab3ALWdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 17:33:32 -0500
Message-ID: <50F1E4A5.4000002@csamuel.org>
Date: Sun, 13 Jan 2013 09:33:09 +1100
From: Chris Samuel <chris@csamuel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        dhowells@redhat.com
Subject: Re: MODSIGN: Modules fail signature verification with -ENOKEY
References: <50EEA4C4.4080103@csamuel.org> <50EFDE31.90709@csamuel.org> <CA+5PVA5hCuTar1F=g5vgT2Cj1ZbF7w+HcWzhATUx7wFs_kuSWw@mail.gmail.com> <50F10278.3050309@csamuel.org> <CA+5PVA7YmAM__aTN=FeGDL-V2njb1-LMbg5xE7FPPNkC2oApyQ@mail.gmail.com>
In-Reply-To: <CA+5PVA7YmAM__aTN=FeGDL-V2njb1-LMbg5xE7FPPNkC2oApyQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/* Please CC, not on LKML */

On 13/01/13 00:08, Josh Boyer wrote:

> On Sat, Jan 12, 2013 at 1:28 AM, Chris Samuel <chris@csamuel.org> wrote:
 >
 >> [...Debian kernel-build...]
>> I'll file a bug against it asking for the it to not strip if
>> CONFIG_MODULE_SIG is set.
>>
>> Thanks for the pointer!
>
> Great.  Glad you figured it out.

It raises a question - if we have CONFIG_MODULE_SIG should we disable 
stripping modules in the top level Makefile as it's going to break things?

The parsing for CONFIG_MODULE_SIG happens right after that for 
INSTALL_MOD_STRIP so the stripping could be disabled with with:

mod_strip_cmd = true
export strip_cmd

cheers,
Chris
-- 
  Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
