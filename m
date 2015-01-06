Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbbAFOei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:34:38 -0500
Received: from mout.web.de ([212.227.15.14]:50360 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbbAFOeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:34:36 -0500
Message-ID: <54ABF260.9020904@users.sourceforge.net>
Date: Tue, 06 Jan 2015 15:34:08 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dominique Martinet <dominique.martinet@cea.fr>,
        Julia Lawall <julia.lawall@lip6.fr>
CC: Latchesar Ionkov <lucho@ionkov.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ron Minnich <rminnich@sandia.gov>,
        v9fs-developer@lists.sourceforge.net,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [V9fs-developer] [PATCH 1/8] fs/9p: Deletion of unnecessary checks
 before the function call "p9_client_clunk"
References: <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A01326.3050306@users.sourceforge.net> <54A06AB9.4020505@users.sourceforge.net> <20150105112206.GC15033@mwanda> <54AB02F3.5020308@users.sourceforge.net> <alpine.DEB.2.02.1501052239290.2025@localhost6.localdomain6> <54AB0844.5090405@users.sourceforge.net> <alpine.DEB.2.02.1501052257270.2025@localhost6.localdomain6> <20150106081253.GA22484@u-galfione> <20150106092719.GB22484@u-galfione>
In-Reply-To: <20150106092719.GB22484@u-galfione>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:dk+xzCgTQuiOuCb76wdE+/nnZCbkUzKVVbHNxfUM2Fza4FGPivM
 FpjEZG63F4diLnyjAGPEq+OwSLKFGo0Z+Om5kOxJIViZ9zCsFRNvoNLzpxA2kdARdo/89xP
 RJSwItiyDVvoTd1e6wZMOzK1RE3RgA/LFP1oHsvO2ruP3OCkLj/N9Z2VR6lwaPdoXG2/U12
 FRd9UiROO4I9oaChYf1Kg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> jumping to label error from a failure in p9_client_fcreate (e.g. EPERM
>> or something perfectly valid) will, with your patch, call clunk with fid
>> == NULL and thus generate a stack trace, while it is a perfectly normal
>> code path that should only return to userspace with EPERM.
> 
> Actually just seen that this precise example is fixed along with more
> similar code paths in subsequents (!) patchs of the set.

Do you refer to my update suggestions with a subject like "One function
call less in v9fs_…" here?


> It could actually be interesting to see if we could get all such
> paths "fixed".

Would you like to see any more specific source code clean-up?
Which kind of fine-tuning have you got in mind?

Regards,
Markus
