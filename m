Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab3AKCiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 21:38:14 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:47269 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3AKCiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 21:38:12 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 10 Jan 2013 18:37:50 -0800
X-Google-Sender-Auth: 5NhJSYgAESERK5VexDulQenS4ZQ
Message-ID: <CAB=NE6Xd6ATWO_1zOcg97sXcnabKBHjrHFetbfGRbDL-x1gqxw@mail.gmail.com>
Subject: rel-html: HTML5 release page for compat-drivers, maybe kernel.org and others
To: Konstantin Ryabitsev <mricon@kernel.org>, backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last step from the compat-wireless --> compat-drivers name change
was to produce a release page for it. I was asked to see if I could
come up with something generic that perhaps could be used by other
projects. I've created a Python release script called rel-html [0] to
generate a simple HTML5 page based on the initializr project for a
base HTML5 template [0]. It currently supports generating new shiny
simple HTML5 pages for compat-drivers and kernel.org. Whether or not
its used for other projects is obviously an option for each project to
choose but hope its simple enough for others to embrace if they so
wish.

It works by allowing a project to add a simple configuration file and
a few hints on where to find releases.

Example for kernel.org:

https://raw.github.com/mcgrof/rel-html/master/rel-html.cfg

Example for compat-drivers:

https://raw.github.com/mcgrof/rel-html/master/projects/compat-drivers.cfg

It currently relies on both the kernel.org and compat-drivers release
model and only refers to releases if each release has respective
ChangeLog and a signature file. Testing releases do not require
ChangeLogs. Right now it does require manual configuration file
updates if a new release is made but to figure out a way to make it
autodetect the latest release is something I'd prefer address with the
community.

To generate a page and see what it spits out you can run and point
your browser to the index.html file:

# For kernel.org:
mcgrof@frijol ~/devel/rel-html (git::master)$ ./rel-html.py  > html/index.html

# For compat-drivers:
mcgrof@frijol ~/devel/rel-html (git::master)$ ./rel-html.py -f
projects/compat-drivers.cfg > html/index.html

Konstantin, let me know if this works for a compat-driver release
page. I also welcome feedback from others for considerations for other
projects and of course I welcome patches.

[0] https://github.com/mcgrof/rel-html
[1] http://www.initializr.com/

  Luis
