Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbaKAR5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 13:57:15 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45444 "EHLO
	jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758762AbaKAR5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 13:57:14 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Nov 2014 13:57:14 EDT
Date: Sat, 1 Nov 2014 18:51:59 +0100
From: Martin Mares <mj@ucw.cz>
To: Tom Gundersen <teg@jklm.no>
Cc: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@vrfy.org>
Subject: udev/hwdb support in pciutils (Re: [PATCH RESEND][pciutils] libpci:
 pci_id_lookup - add udev/hwdb support)
Message-ID: <mj+md-20141101.174026.23374.albireo@ucw.cz>
References: <CAG-2HqXsEBB_nxUF4gza-eTsUjmysYR7iPEjJPUFyR1rC2KGMg@mail.gmail.com>
 <CAPXgP12MLL_Z5gyrCndQLRT6SR_TJi9xHp1HkHMX1ahwnxx3yw@mail.gmail.com>
 <mj+md-20131215.091609.28546.nikam@ucw.cz>
 <CAPXgP10+1WtX8_xN+QSHvKws01hbKhP3FN95sXk9EtezdSPtqg@mail.gmail.com>
 <mj+md-20131215.110132.29802.nikam@ucw.cz>
 <CAG-2HqUGcBB1-YUvLZpqm1EZ69OSksa+iGcCEqVWxYsehDqx8Q@mail.gmail.com>
 <CAG-2HqWYZtTMNRvLwWRy-5_5yb=EasiWzpL2xc0_42SyP=bg1w@mail.gmail.com>
 <CAG-2HqVS1avGdvi6SFc1dq0sCzcA4z5sZUBH4WhpNN87tZrnxA@mail.gmail.com>
 <mj+md-20140212.194230.3341.nikam@ucw.cz>
 <CAG-2HqUN3Ftdd=3XSe-et3pgXy71Fu9DbMqREQDycwL4kD9Paw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG-2HqUN3Ftdd=3XSe-et3pgXy71Fu9DbMqREQDycwL4kD9Paw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom!

The support for hwdb has finally landed in mainline pciutils.

I have modified your patch to bring it closer to the rest of device
naming logic. Namely:

  •  The interface to HWDB now lives in a separate source file
     lib/names-hwdb.c. It is called from the main entry point
     to the name resolver (lib/names.c).

  •  Resolved names are cached in the hash table and they participate
     in the system of priorities. They have lower priority than pci.ids,
     but higher than remote lookups via DNS. (Therefore if a distro
     decides not to ship pci.ids, hwdb is used exclusively for all
     local lookups.)

  •  There is a flag to suppress the use of HWDB (PCI_LOOKUP_NO_HWDB)
     and also a configuration parameter for the same (hwdb.disable).

Aside of the README, everything should be ready for a public release.
Could you please verify that it still works for you?

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
Uncle Ed's Rule of Thumb:  Never use your thumb for a rule.
