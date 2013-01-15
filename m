Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab3AONbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:31:48 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:38710 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057Ab3AONbq (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 15 Jan 2013 08:31:46 -0500
Message-Id: <50F5684F02000078000B5CC1@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Tue, 15 Jan 2013 13:31:43 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Xen: properly bound buffer access when parsing
 cpu/*/availability
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartB889102F.2__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartB889102F.2__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

At the same time reduce the local buffers to 16 bytes each.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -25,10 +25,10 @@ static void disable_hotplug_cpu(int cpu)
 static int vcpu_online(unsigned int cpu)
 {
 	int err;
-	char dir[32], state[32];
+	char dir[16], state[16];
=20
 	sprintf(dir, "cpu/%u", cpu);
-	err =3D xenbus_scanf(XBT_NIL, dir, "availability", "%s", state);
+	err =3D xenbus_scanf(XBT_NIL, dir, "availability", "%15s", state);
 	if (err !=3D 1) {
 		if (!xen_initial_domain())
 			printk(KERN_ERR "XENBUS: Unable to read cpu =
state\n");




--=__PartB889102F.2__=
Content-Type: text/plain; name="xen-vcpu-availability-field-width.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="xen-vcpu-availability-field-width.patch"

Xen: properly bound buffer access when parsing cpu/*/availability=0A=0AAt =
the same time reduce the local buffers to 16 bytes each.=0A=0ASigned-off-by=
: Jan Beulich <jbeulich@suse.com>=0A=0A--- a/drivers/xen/cpu_hotplug.c=0A++=
+ b/drivers/xen/cpu_hotplug.c=0A@@ -25,10 +25,10 @@ static void disable_hot=
plug_cpu(int cpu)=0A static int vcpu_online(unsigned int cpu)=0A {=0A 	=
int err;=0A-	char dir[32], state[32];=0A+	char dir[16], state[16];=0A=
 =0A 	sprintf(dir, "cpu/%u", cpu);=0A-	err =3D xenbus_scanf(XBT_NI=
L, dir, "availability", "%s", state);=0A+	err =3D xenbus_scanf(XBT_NI=
L, dir, "availability", "%15s", state);=0A 	if (err !=3D 1) {=0A 		=
if (!xen_initial_domain())=0A 			printk(KERN_ERR "XENBUS: =
Unable to read cpu state\n");=0A
--=__PartB889102F.2__=--
