Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab3A2UDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:03:18 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50464 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab3A2UDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:03:16 -0500
Message-ID: <1359489673.816.25.camel@falcor1.watson.ibm.com>
Subject: Re: [RFC 1/1] ima: digital signature verification using asymmetric
 keys
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, dhowells@redhat.com,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 29 Jan 2013 15:01:13 -0500
In-Reply-To: <20130129182012.GA21002@redhat.com>
References: <1358895228.2408.14.camel@falcor1>
	 <CALLzPKbNVV+iWzUcsxq0Lk-Hz2BVpCBsEbjHdnRAyjDsF5___g@mail.gmail.com>
	 <20130125210157.GA13152@redhat.com>
	 <CALLzPKY9E8VaFf1GUstTnCeYwLOTm6ozdjJFDwSKWk_JR6QF5w@mail.gmail.com>
	 <20130128151527.GA5868@redhat.com>
	 <CALLzPKbjmoLGMVgY-GygZ9ScV1GNHKaKHGYsHc4=CeoYPL4rmw@mail.gmail.com>
	 <20130128185625.GC5868@redhat.com> <1359404149.3906.75.camel@falcor1>
	 <20130128202241.GB14405@redhat.com> <1359424135.3906.247.camel@falcor1>
	 <20130129182012.GA21002@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012920-9360-0000-0000-00000FDEF726
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 13:20 -0500, Vivek Goyal wrote:
> On Mon, Jan 28, 2013 at 08:48:55PM -0500, Mimi Zohar wrote:
> 
> [..]
> > > Hi Mimi,
> > > 
> > > By policy you mean ima rules here? So I can either enable default rules
> > > (tcb default rules for appraisal and measurement) by using kernel command
> > > line options or dynamically configure my own rules using /sysfs interface?
> > > 
> > > If yes, AFAIK, existing inputtable policies do not allow this selective
> > > mode where we do appraisal only on signed executable. That means I shall
> > > have to extend the way policies can be specified so that one specify
> > > that appraise only signed files?
> > 
> > We've just added the ability of defining the method for appraising a
> > file and defining rules in terms of the filesystem UUID.  Extending the
> > IMA policy shouldn't be a problem, but I'm not sure how you would go
> > about adding support for only appraising files with digital signatures.
> 
> Hi Mimi,
> 
> Can we add another field to ima_rule_entry, say .enforcement to control
> the behavior of .action. Possible values of .enforcement could be, say.
> 
> ALL
> SIGNED_ONLY
> 
> ALL will be default. And with .action= MEASURE, one could possibly use
> .enforcement=SIGNED_ONLY.

Other than the .action being '.action=APPRAISE', not 'MEASURE',
something like what you're suggesting, could work.  How about extending
the new 'appraise_type=' option?   The appraise_type enforces a
particular type (eg. hash, signature) of verification. 

option: appraise_type:= [imasig[,signed_only]]
eg. appraise_type=imasig,signed_only

thanks,

Mimi

