Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965284Ab3IEKcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:32:11 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37177 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935687Ab3IEKcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:32:05 -0400
Date: Thu, 5 Sep 2013 11:31:58 +0100
From: Matt Fleming <matt@console-pimps.org>
To: joeyli <jlee@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 11/18] Hibernate: introduced RSA key-pair to verify
 signature of snapshot
Message-ID: <20130905103158.GM28598@console-pimps.org>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-12-git-send-email-jlee@suse.com>
 <20130905085348.GJ28598@console-pimps.org>
 <1378376016.6193.71.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378376016.6193.71.camel@linux-s257.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Sep, at 06:13:36PM, joeyli wrote:
> This S4WakeKey is a VOLATILE variable that could not modify by
> SetVariable() at runtime. So, it's read only even through efivars. 
> 
> Does it what your concern?
 
No, the UEFI spec probibits certain runtime functions from being
executed concurrently on separate cpus and the spinlock used in the
efivars code ensures that we adhere to that restriction. See table 31 in
section 7.1 of the UEFI 2.4 spec for the list of services that are
non-reentrant.

The problem isn't that we want to avoid simultaneous access to
S4WakeKey, it's that we can't invoke any of the variable runtime service
functions concurrently.

-- 
Matt Fleming, Intel Open Source Technology Center
