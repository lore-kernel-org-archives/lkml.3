Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaJTKpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:45:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:46890 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaJTKpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:45:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="402874801"
Date: Mon, 20 Oct 2014 13:45:15 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Greg KH <greg@kroah.com>, Peter Huewe <peterhuewe@gmx.de>,
        Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, josh.triplett@intel.com,
        christophe.ricard@gmail.com, will.c.arthur@intel.com,
        monty.wiseman@intel.com
Subject: Re: [PATCH v3 4/6] tpm: TPM 2.0 sysfs attributes
Message-ID: <20141020104515.GB5647@intel.com>
References: <1413372916-12091-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1413372916-12091-5-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141016093146.GA25070@kroah.com>
 <20141016160358.GB12979@intel.com>
 <CA+i0qc4XgqF4c+TcyXvPG6XFs_LNvWWRs8p_=-iGeD_bQU9Zpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+i0qc4XgqF4c+TcyXvPG6XFs_LNvWWRs8p_=-iGeD_bQU9Zpw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 12:09:27AM +0300, Tomas Winkler wrote:
> >
> > Here the options are limited because misc_register already spawns
> > KOBJ_ADD. Not much to do unless we would wipe the current use of
> > misc driver completely.
> 
> I would strongly recommend to drop the misc layer here, as tpm itself
> can provide the needed abstraction for the devices.

This is exactly what I'm going to do for v4 of the patch set and take
the rtc subsystem as a guideline how to structure things in proper way.

It is ABI break but if you look at the TPM1 sysfs attributes most of
them haven't been ever machine readable anyway so I'll at least give it
shot and a take the feedback. I'm fully aware that doing such thing is 
comparable to killing your own mother :)

Past experiences of trying to do such thing [1] have not been succesful
but on the other hand this is very different scenario and different user
volumes.

It would make sense to rip off all the "human-only" TPM1 attributes in
the same round. I'm wondering what is the set of sysfs attributes is
that TrouSerS is dependent of? I would suggest to leave that subset
available and remove attributes such as 'pcrs' that breaks all the
conventions.

[1] http://lwn.net/Articles/172306/

/Jarkko
