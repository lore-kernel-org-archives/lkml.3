Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaKFRMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:12:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbaKFRMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:12:19 -0500
Date: Thu, 6 Nov 2014 11:12:13 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Seth Jennings <sjenning@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
Message-ID: <20141106171213.GB4075@treble.hsd1.ky.comcast.net>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <545B98E6.2070009@suse.cz>
 <20141106165748.GB14689@cerebellum.variantweb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141106165748.GB14689@cerebellum.variantweb.net>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 10:57:48AM -0600, Seth Jennings wrote:
> On Thu, Nov 06, 2014 at 04:51:02PM +0100, Jiri Slaby wrote:
> > On 11/06/2014, 03:39 PM, Seth Jennings wrote:
> > > +/* must be called with lpc_mutex held */
> > > +static int lpc_enable_patch(struct lpc_patch *patch)
> > 
> > The question I want to raise here is whether we need two-state
> > registration: register+enable. We don't in kGraft. Why do you?
> 
> We actually don't in kpatch either and this was a late change for this
> patchset.  The thinking was that, while the patch modules would normally
> call lpc_register_patch() and lpc_enable_patch() in the same way all the
> time, breaking them up created more symmetric code and gives more flexibility
> to the API.
> 
> Josh might like to elaborate here.

Yes, this was my brilliant idea :-)  I like it because it makes the
register/unregister interfaces more symmetrical.

We already have to separate disable and unregister so that a patch can
be disabled from sysfs, so it makes sense IMO to likewise separate
register and enable.

The downside is an extra function call.  The upside is it makes the code
cleaner, and the API easier to understand and more flexible.

-- 
Josh
