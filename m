Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3IEOuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:50:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab3IEOuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:50:24 -0400
Date: Thu, 5 Sep 2013 10:50:13 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: adi@drcomp.erfurt.thur.de
Subject: Re: ALSA: hdspm - AES32: Enable TCO/Sync-In in
 snd_hdspm_put_sync_ref()
Message-ID: <20130905145013.GC15894@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	adi@drcomp.erfurt.thur.de
References: <20130905013837.9F84A660DA9@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905013837.9F84A660DA9@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 01:38:37AM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=2d60fc7f7d3d79e5646646bb34811961f19d111a
 > Commit:     2d60fc7f7d3d79e5646646bb34811961f19d111a
 > Parent:     dbae4a0c8d8794df1a6bd7e644ed94b915f46f7e
 > Author:     Adrian Knoth <adi@drcomp.erfurt.thur.de>
 > AuthorDate: Fri Jul 5 11:28:15 2013 +0200
 > Committer:  Takashi Iwai <tiwai@suse.de>
 > CommitDate: Fri Jul 5 14:52:42 2013 +0200
 > 
 >     ALSA: hdspm - AES32: Enable TCO/Sync-In in snd_hdspm_put_sync_ref()
 
 >  static int hdspm_autosync_ref(struct hdspm *hdspm)
 >  {
  ...
 > +		unsigned int syncref = (status >> HDSPM_AES32_syncref_bit) & 0xF;
 > +		if ((syncref >= HDSPM_AES32_AUTOSYNC_FROM_WORD) &&
 > +				(syncref <= HDSPM_AES32_AUTOSYNC_FROM_SYNC_IN)) {
 >  			return syncref;
 > +		}

Because syncref is unsigned, the first part of that if always evaluates true.
(it will always be >0)

	Dave

