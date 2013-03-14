Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab3CNJ35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:29:57 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:28615 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab3CNJ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:29:56 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5r/VwSUgfH8=
X-RZG-CLASS-ID: mo00
Date: Thu, 14 Mar 2013 10:29:52 +0100
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH 1/1] Drivers: hv: Add a new driver to support host
 initiated backup
Message-ID: <20130314092952.GA29201@aepfle.de>
References: <1363114406-30575-1-git-send-email-kys@microsoft.com>
 <20130312184839.GA30976@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130312184839.GA30976@aepfle.de>
User-Agent: Mutt/1.5.21.rev5641 (2013-02-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, Olaf Hering wrote:

> On Tue, Mar 12, K. Y. Srinivasan wrote:
> 
> > +static int vss_operate(int operation)
> > +{
> > +	char *fs_op;
> > +	char cmd[512];
> > +	char buf[512];
> > +	FILE *file;
> > +	char *p;
> > +	char *x;
> > +	int error;
> > +
> > +	switch (operation) {
> > +	case VSS_OP_FREEZE:
> > +		fs_op = "-f ";
> > +		break;
> > +	case VSS_OP_THAW:
> > +		fs_op = "-u ";
> > +		break;
> > +	}
> > +
> > +	sprintf(cmd, "%s", "mount | grep ^/dev/ | awk '{print $3 }'");
> 
> I think this can be char cmd[] = "mount | awk '/^\/dev\/ { print $3'";

After thinking about this part, perhaps start a helper script which has
to provide as output the list of the mounted filesystems?

Olaf
